/**
 * VertexShield Lua Protector v4
 * ---------------------------------------------------------------------------
 * A layered Lua source protector that emits a self-defending loader.
 *
 * Payload pipeline (TypeScript side):
 *   utf8 bytes -> LZSS compress -> affine byte scatter -> CBC-ish stream cipher
 *   -> base64 with a shuffled per-build alphabet -> random-sized chunks stored
 *   under shuffled numeric keys.
 *
 * Loader pipeline (Lua side, executed inside a flattened state machine):
 *   integrity checks -> chunk reassembly -> ciphertext checksum -> base64
 *   decode -> decrypt -> inverse scatter -> LZSS inflate -> plaintext checksum
 *   -> load() -> chunk identity check -> sandboxed execution -> env report.
 *
 * Runtime defence layers:
 *   - anti-dump  : payload/plaintext checksums, debug hook detection, stack
 *                  depth heuristics, clock-freeze detection, loaded chunk
 *                  identity verification, immediate source wipe.
 *   - anti-hook  : native (C) closure verification of the primitives the
 *                  loader depends on, string/table metatable tamper checks,
 *                  hook-framework API scanning, getrenv()/getgenv() divergence.
 *   - env logging: technical environment snapshot (executor identity, API
 *                  surface, place/job ids, triggered flags) that is optionally
 *                  echoed to the console and/or POSTed to an owner webhook.
 *   - watchdog   : periodic re-verification of the environment while running.
 */

export type ProtectionLevel = "standard" | "hardened" | "paranoid";
export type ResponseMode = "silent" | "error" | "hang" | "corrupt" | "report";

export interface LuaProtectionOptions {
  /** Overall aggressiveness. Defaults to "hardened". */
  level?: ProtectionLevel;
  /** Detect attempts to dump / decompile the payload. Defaults to true. */
  antiDump?: boolean;
  /** Detect hooked primitives and hook frameworks. Defaults to true. */
  antiHook?: boolean;
  /** Collect + emit an environment snapshot. Defaults to false. */
  envLogging?: boolean;
  /** Echo the environment snapshot to the executor console. */
  envLogConsole?: boolean;
  /** Optional endpoint the snapshot is POSTed to (owner controlled). */
  webhookUrl?: string;
  /** What to do when a check trips. Defaults to "silent". */
  responseMode?: ResponseMode;
  /** Periodically re-verify the environment. Defaults to level === "paranoid". */
  watchdog?: boolean;
  /** Flatten the loader into a randomized state machine. Defaults to true. */
  flatten?: boolean;
  /** Refuse to run twice inside the same environment. Defaults to false. */
  reentrancyGuard?: boolean;
  /** Identifier embedded into reports (e.g. the paste id). */
  scriptId?: string;
  /** Emit the VertexShield banner comment. Defaults to true. */
  banner?: boolean;
  /** Deterministic build seed (useful for tests / reproducible builds). */
  seed?: number;
}

export interface LuaProtectionStats {
  sourceBytes: number;
  compressedBytes: number;
  cipherChars: number;
  chunks: number;
  ratio: number;
  checks: number;
}

export const LUA_PROTECTION_DEFAULTS = {
  level: "hardened" as ProtectionLevel,
  antiDump: true,
  antiHook: true,
  envLogging: false,
  envLogConsole: false,
  webhookUrl: "",
  responseMode: "silent" as ResponseMode,
  watchdog: undefined as boolean | undefined,
  flatten: true,
  reentrancyGuard: false,
  scriptId: "",
  banner: true,
  seed: undefined as number | undefined,
};

/* ------------------------------------------------------------------ *
 * Deterministic RNG (Lehmer) — mirrored 1:1 in the generated Lua so
 * both sides derive identical pseudo random sequences.
 * ------------------------------------------------------------------ */

/**
 * LCG kept far below 2^31 so the identical sequence is produced by Lua builds
 * with 32 bit integers, Luau doubles and this TypeScript.
 */
const LEHMER_MOD = 65521; // largest prime below 2^16
const LEHMER_MUL = 31; // 31 * 65521 << 2^31

function makeRng(seed: number) {
  let state = seed % LEHMER_MOD;
  return () => {
    state = (state * LEHMER_MUL + 7) % LEHMER_MOD;
    return state / LEHMER_MOD;
  };
}

const rndInt = (rnd: () => number, min: number, max: number) =>
  min + Math.floor(rnd() * (max - min + 1));

const shuffle = <T,>(arr: T[], rnd: () => number): T[] => {
  const out = arr.slice();
  for (let i = out.length - 1; i > 0; i--) {
    const j = Math.floor(rnd() * (i + 1));
    [out[i], out[j]] = [out[j], out[i]];
  }
  return out;
};

const gcd = (a: number, b: number): number => (b === 0 ? a : gcd(b, a % b));

/* ------------------------------------------------------------------ *
 * LZSS (4 KiB window / 18 byte max match) — classic token layout:
 *   flag byte, bit set = literal, bit clear = 2 byte match token
 *   match token = [dist-1 low 8][dist-1 high 4 | (len-3) << 4]
 * ------------------------------------------------------------------ */

const LZ_WINDOW = 4096;
const LZ_MAX_MATCH = 18;
const LZ_MIN_MATCH = 3;
const LZ_HASH_BITS = 15;
const LZ_MAX_CHAIN = 48;
/** Above this size compression is skipped (still encrypted + scattered). */
const LZ_MAX_INPUT = 6 * 1024 * 1024;

export function lzssCompress(data: Uint8Array): Uint8Array {
  const n = data.length;
  if (n < LZ_MIN_MATCH) return data.slice();

  const head = new Int32Array(1 << LZ_HASH_BITS).fill(-1);
  const prev = new Int32Array(n).fill(-1);
  const hashAt = (i: number) =>
    ((data[i] << 10) ^ (data[i + 1] << 5) ^ data[i + 2]) & ((1 << LZ_HASH_BITS) - 1);

  const out: number[] = [];
  let group: { literal: boolean; a: number; b: number }[] = [];

  const flush = () => {
    if (group.length === 0) return;
    let flags = 0;
    for (let i = 0; i < group.length; i++) if (group[i].literal) flags |= 1 << i;
    out.push(flags);
    for (const tok of group) {
      if (tok.literal) {
        out.push(tok.a);
      } else {
        out.push(tok.a & 0xff);
        out.push((tok.a >> 8) & 0x0f | ((tok.b & 0x0f) << 4));
      }
    }
    group = [];
  };

  let pos = 0;
  while (pos < n) {
    let bestLen = 0;
    let bestPos = -1;

    if (pos + LZ_MIN_MATCH <= n) {
      const h = hashAt(pos);
      const maxLen = Math.min(LZ_MAX_MATCH, n - pos);
      let cand = head[h];
      let tries = 0;
      while (cand >= 0 && tries < LZ_MAX_CHAIN) {
        const dist = pos - cand;
        if (dist > LZ_WINDOW) break;
        let l = 0;
        while (l < maxLen && data[cand + l] === data[pos + l]) l++;
        if (l > bestLen) {
          bestLen = l;
          bestPos = cand;
          if (l >= maxLen) break;
        }
        cand = prev[cand];
        tries++;
      }
      prev[pos] = head[h];
      head[h] = pos;
    }

    if (bestLen >= LZ_MIN_MATCH) {
      group.push({ literal: false, a: pos - bestPos - 1, b: bestLen - LZ_MIN_MATCH });
      for (let k = 1; k < bestLen && pos + k + LZ_MIN_MATCH <= n; k++) {
        const hh = hashAt(pos + k);
        prev[pos + k] = head[hh];
        head[hh] = pos + k;
      }
      pos += bestLen;
    } else {
      group.push({ literal: true, a: data[pos], b: 0 });
      pos += 1;
    }

    if (group.length === 8) flush();
  }
  flush();
  return Uint8Array.from(out);
}

/* ------------------------------------------------------------------ *
 * Cipher helpers
 * ------------------------------------------------------------------ */

/**
 * Per byte key material. Every term is reduced before it is combined so no
 * intermediate ever exceeds 2^31 — the emitted Lua must match bit for bit.
 */
const keystreamByte = (i: number, k1: number, k2: number, k3: number) =>
  (k1 + (i % 256) * k2 + (i % k3) * 7 + Math.floor(i / 64) % 256) & 0xff;

function cbcEncrypt(plain: Uint8Array, k1: number, k2: number, k3: number, iv: number): Uint8Array {
  const out = new Uint8Array(plain.length);
  let chain = iv;
  for (let i = 0; i < plain.length; i++) {
    const v = (plain[i] + keystreamByte(i, k1, k2, k3) + chain) % 256;
    out[i] = v;
    chain = v;
  }
  return out;
}

/**
 * Bijective affine scatter: dest = (i * A + B) mod n, gcd(A, n) === 1.
 * The destination index is advanced incrementally instead of multiplying, so
 * the index never exceeds 2n and stays exact on 32 bit integer Lua builds.
 */
function affineScatter(input: Uint8Array, A: number, B: number): Uint8Array {
  const n = input.length;
  const out = new Uint8Array(n);
  let dest = B % n;
  for (let i = 0; i < n; i++) {
    out[dest] = input[i];
    dest += A % n;
    if (dest >= n) dest -= n;
  }
  return out;
}

/**
 * Rolling twin hash.
 * Deliberately kept below 2^31 intermediates: Lua builds with 32 bit integers
 * (and Luau doubles) must produce the exact same digest as this TypeScript.
 */
export const HASH_M1 = 1048573; // prime
export const HASH_R1 = 131;
export const HASH_M2 = 999983; // prime
export const HASH_R2 = 137;

function rollingHash(bytes: ArrayLike<number>): { h1: number; h2: number } {
  let h1 = 7;
  let h2 = 11;
  for (let i = 0; i < bytes.length; i++) {
    const b = bytes[i];
    h1 = (h1 * HASH_R1 + b) % HASH_M1;
    h2 = (h2 * HASH_R2 + b * 3 + 7) % HASH_M2;
  }
  return { h1, h2 };
}

function rollingHashString(str: string): { h1: number; h2: number } {
  let h1 = 7;
  let h2 = 11;
  for (let i = 0; i < str.length; i++) {
    const b = str.charCodeAt(i);
    h1 = (h1 * HASH_R1 + b) % HASH_M1;
    h2 = (h2 * HASH_R2 + b * 3 + 7) % HASH_M2;
  }
  return { h1, h2 };
}

/**
 * Base64 with a shuffled alphabet.
 * Pool deliberately excludes `"`, `'`, `\`, `[`, `]` so emitted Lua string
 * literals never need escaping.
 */
const B64_POOL =
  "!#$%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ^_abcdefghijklmnopqrstuvwxyz{|}~";

function base64Encode(bytes: Uint8Array, alphabet: string): string {
  let out = "";
  for (let i = 0; i < bytes.length; i += 3) {
    const b0 = bytes[i];
    const b1 = i + 1 < bytes.length ? bytes[i + 1] : 0;
    const b2 = i + 2 < bytes.length ? bytes[i + 2] : 0;
    out += alphabet[b0 >> 2];
    out += alphabet[((b0 & 3) << 4) | (b1 >> 4)];
    if (i + 1 < bytes.length) out += alphabet[((b1 & 15) << 2) | (b2 >> 6)];
    if (i + 2 < bytes.length) out += alphabet[b2 & 63];
  }
  return out;
}

/* ------------------------------------------------------------------ *
 * Lua emission helpers
 * ------------------------------------------------------------------ */

const LUA_KEYWORDS = new Set([
  "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if",
  "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while",
]);

function makeNamer(rnd: () => number) {
  const used = new Set<string>();
  return () => {
    for (let attempt = 0; attempt < 64; attempt++) {
      const name =
        "_" +
        Math.floor(rnd() * 1e9).toString(36) +
        Math.floor(rnd() * 1e9).toString(36);
      if (!LUA_KEYWORDS.has(name) && !used.has(name)) {
        used.add(name);
        return name;
      }
    }
    const fallback = `_vs${used.size}`;
    used.add(fallback);
    return fallback;
  };
}

const luaQuote = (s: string) => `"${s.replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`;

const HOOK_APIS = [
  "hookfunction", "hookmetamethod", "replaceclosure", "clonefunction", "newcclosure",
  "checkcaller", "isourclosure", "getrawmetatable", "setreadonly", "isreadonly",
  "getnamecallmethod", "setnamecallmethod", "getcallbackvalue", "setrawmetatable",
  "isfunctionattached", "getcustomassets", "getcallingscript", "getcaller",
];

const DUMP_APIS = [
  "decompile", "dump", "saveinstance", "getscriptbytecode", "script_closure",
  "getscriptclosure", "getscripts", "getloadedmodules", "getgc", "getinstances",
  "getnilinstances", "getconnections", "cloneref", "gethui", "getallthreads",
  "getthreadidentity", "setthreadidentity", "getspecialinfo",
];

const ENV_PROBE_APIS = [
  "identifyexecutor", "getexecutorname", "getgenv", "getrenv", "getsenv", "getreg",
  "hookfunction", "hookmetamethod", "newcclosure", "checkcaller", "iscclosure",
  "decompile", "dump", "saveinstance", "getscriptbytecode", "getgc", "getinstances",
  "getconnections", "request", "http_request", "syn", "krnl", "fluxus", "queue_on_teleport",
  "setclipboard", "gethui", "Drawing", "crypt", "task",
];

const RESPONSE_MODES: Record<ResponseMode, number> = {
  silent: 1,
  error: 2,
  hang: 3,
  corrupt: 4,
  report: 5,
};

const FAKE_ERRORS = [
  "attempt to index nil value",
  "attempt to call a nil value",
  "attempt to perform arithmetic on a nil value",
  "attempt to concatenate a nil value",
  "attempt to compare nil with number",
];

interface Block {
  body: string[];
}

export function protectLua(source: string, options: LuaProtectionOptions = {}): string {
  if (!source || source.trim().length === 0) return "";

  const opts = { ...LUA_PROTECTION_DEFAULTS, ...options };
  const level = opts.level ?? "hardened";
  const paranoid = level === "paranoid";
  const hardened = level === "hardened" || paranoid;
  const antiDump = opts.antiDump !== false;
  const antiHook = opts.antiHook !== false;
  const flatten = opts.flatten !== false;
  const envLogging = !!opts.envLogging;
  const watchdog = opts.watchdog ?? paranoid;
  const responseMode = RESPONSE_MODES[opts.responseMode ?? "silent"] ?? 1;

  const seed = Math.abs(Math.floor(opts.seed ?? Math.random() * 1e9)) % LEHMER_MOD || 12345;
  const rnd = makeRng(seed);
  const name = makeNamer(rnd);

  /* ---------------- 1. payload pipeline ---------------- */

  const srcBytes = new TextEncoder().encode(source);
  const compressible = srcBytes.length <= LZ_MAX_INPUT;
  let body = compressible ? lzssCompress(srcBytes) : srcBytes.slice();
  const compressed = compressible && body.length < srcBytes.length;
  if (!compressed) body = srcBytes.slice();

  const payload = new Uint8Array(body.length + 1);
  payload[0] = compressed ? 1 : 0;
  payload.set(body, 1);

  const n = payload.length;
  let A = rndInt(rnd, 65537, 1000003) | 1;
  while (gcd(A, n) !== 1) A += 2;
  const B = rndInt(rnd, 0, Math.max(0, n - 1));
  const scattered = affineScatter(payload, A, B);

  const k1 = rndInt(rnd, 1, 255);
  const k2 = rndInt(rnd, 1, 255);
  const k3 = rndInt(rnd, 7, 251);
  const iv = rndInt(rnd, 0, 255);
  const cipher = cbcEncrypt(scattered, k1, k2, k3, iv);

  const alphabet = shuffle(B64_POOL.split("").slice(0, 64), rnd).join("");
  const cipherText = base64Encode(cipher, alphabet);
  const cipherHash = rollingHashString(cipherText);

  const plainHash = rollingHash(srcBytes);

  // chunk the ciphertext under shuffled numeric keys
  const chunkSize = rndInt(rnd, 90, 220);
  const pieces: string[] = [];
  for (let i = 0; i < cipherText.length; i += chunkSize) pieces.push(cipherText.slice(i, i + chunkSize));
  const keys: number[] = [];
  const usedKeys = new Set<number>();
  for (let i = 0; i < pieces.length; i++) {
    let k = rndInt(rnd, 1000, 999999);
    while (usedKeys.has(k)) k = rndInt(rnd, 1000, 999999);
    usedKeys.add(k);
    keys.push(k);
  }
  const orderMask = rndInt(rnd, 100, 40000);
  // The order list holds the chunk keys in *logical* order (masked). Only the
  // physical emission order of the chunk lines is shuffled, so the payload
  // cannot be reassembled by reading the loader top to bottom.
  const orderCsv = keys.map((k) => k + orderMask).join(",");
  const emission = shuffle(
    pieces.map((p, i) => ({ key: keys[i], piece: p })),
    rnd,
  );

  /* ---------------- 2. names ---------------- */

  const X = name(); // shared context table (single upvalue for every block)
  const chunkName = `=${name().slice(1).toUpperCase()}`;
  const fakeError = `${FAKE_ERRORS[rndInt(rnd, 0, FAKE_ERRORS.length - 1)]} (field '${name().slice(1, 7)}')`;
  const sessionId = `${rndInt(rnd, 100000, 999999)}${rndInt(rnd, 1000, 9999)}`;
  const maxDepth = paranoid ? 12 : 24;

  const L: string[] = [];
  const push = (...lines: string[]) => L.push(...lines);

  /* ---------------- 3. header ---------------- */

  if (opts.banner) {
    push(
      `--[[ VertexShield Protection v4.0 | ${level} | ${[
        antiDump ? "anti-dump" : null,
        antiHook ? "anti-hook" : null,
        envLogging ? "env-log" : null,
        watchdog ? "watchdog" : null,
      ]
        .filter(Boolean)
        .join("+") || "core"} ]]`,
    );
  }

  push("do");
  push(`local ${X} = {}`);

  // cipher / scatter constants
  push(
    `${X}.a1=${k1}; ${X}.a2=${k2}; ${X}.a3=${k3}; ${X}.iv=${iv}; ${X}.sa=${A}; ${X}.sb=${B}; ${X}.mode=${responseMode}; ${X}.fatal=false;`,
  );
  push(`${X}.e1=${cipherHash.h1}; ${X}.e2=${cipherHash.h2}; ${X}.pl=${srcBytes.length}; ${X}.p1=${plainHash.h1}; ${X}.p2=${plainHash.h2};`);
  push(`${X}.seed=${seed}; ${X}.om=${orderMask}; ${X}.sid=${luaQuote(sessionId)}; ${X}.pid=${luaQuote(opts.scriptId || "")};`);
  push(`${X}.emsg=${luaQuote(fakeError)}; ${X}.cn=${luaQuote(chunkName)};`);
  push(`${X}.alpha=${luaQuote(alphabet)};`);
  push(`${X}.order=${luaQuote(orderCsv)};`);

  // stdlib handles (also hides which globals the loader touches)
  push(
    `${X}.sbyte=string.byte; ${X}.schar=string.char; ${X}.ssub=string.sub; ${X}.srep=string.rep; ${X}.sfmt=string.format; ${X}.gmatch=string.gmatch;`,
  );
  push(`${X}.tconcat=table.concat; ${X}.floor=math.floor; ${X}.pcall=pcall; ${X}.type=type; ${X}.tonumber=tonumber; ${X}.pairs=pairs;`);
  push(`${X}.ld=loadstring or load; ${X}.rawget=rawget; ${X}.gmt=getmetatable;`);

  // environment handles
  push(
    `${X}.genvf=${X}.rawget(_G,"getgenv"); ${X}.env=(${X}.type(${X}.genvf)=="function") and (function() local ok,v=${X}.pcall(${X}.genvf) if ok and ${X}.type(v)=="table" then return v end end)() or _G;`,
  );
  push(`${X}.dbg=${X}.rawget(_G,"debug"); ${X}.hasdbg=(${X}.type(${X}.dbg)=="table");`);
  push(
    `${X}.clock=${X}.rawget(_G,"tick"); if ${X}.type(${X}.clock)~="function" then ${X}.clock=(os and os.clock) or nil end`,
  );

  /* ---------------- 4. helper functions ---------------- */

  let checkCount = 0;
  const flag = (code: number) => {
    checkCount++;
    return `${X}.flag(${code})`;
  };

  push(`${X}.flags={}`);
  push(`${X}.flag=function(c) ${X}.flags[#${X}.flags+1]=c end`);

  // Lehmer PRNG (same constants as the TS side)
  push(
    `${X}.rnd=function() ${X}.seed=(${X}.seed*${LEHMER_MUL}+7)%${LEHMER_MOD} return ${X}.seed/${LEHMER_MOD} end`,
  );

  // native closure probe: true = native, false = user Lua replacement, nil = unknown
  push(`${X}.native=function(f)`);
  push(`  if ${X}.type(f)~="function" then return false end`);
  push(`  if ${X}.hasdbg then`);
  push(`    if ${X}.type(${X}.dbg.getinfo)=="function" then`);
  push(`      local ok,inf=${X}.pcall(${X}.dbg.getinfo,f)`);
  push(`      if ok and ${X}.type(inf)=="table" and inf.what then`);
  push(`        local w=${X}.ssub(inf.what,1,1)`);
  push(`        if w=="C" or w=="J" then return true end`);
  push(`        if w=="L" then return false end`);
  push(`      end`);
  push(`    end`);
  push(`    if ${X}.type(${X}.dbg.info)=="function" then`);
  push(`      local ok,s=${X}.pcall(${X}.dbg.info,f,"s")`);
  push(`      if ok and ${X}.type(s)=="string" then`);
  push(`        if s=="=[C]" then return true end`);
  push(`        if #s>0 then return false end`);
  push(`      end`);
  push(`    end`);
  push(`  end`);
  push(`  local isc=${X}.rawget(${X}.env,"iscclosure")`);
  push(`  if ${X}.type(isc)=="function" then`);
  push(`    local ok,r=${X}.pcall(isc,f)`);
  push(`    if ok then return r and true or false end`);
  push(`  end`);
  push(`  return nil`);
  push(`end`);

  // twin rolling hash over a Lua string
  push(`${X}.hash=function(s)`);
  push(`  local h1,h2=7,11`);
  push(`  for i=1,#s do`);
  push(`    local b=${X}.sbyte(s,i)`);
  push(`    h1=(h1*${HASH_R1}+b)%${HASH_M1}`);
  push(`    h2=(h2*${HASH_R2}+b*3+7)%${HASH_M2}`);
  push(`  end`);
  push(`  return h1,h2`);
  push(`end`);

  // base64 decode (custom alphabet)
  push(`${X}.rev={}`);
  push(`for _i=1,64 do ${X}.rev[${X}.sbyte(${X}.alpha,_i)]=_i-1 end`);
  push(`${X}.b64=function(s)`);
  push(`  local out,oi,acc,bits={},0,0,0`);
  push(`  for i=1,#s do`);
  push(`    local v=${X}.rev[${X}.sbyte(s,i)]`);
  push(`    if v then`);
  push(`      acc=acc*64+v`);
  push(`      bits=bits+6`);
  push(`      if bits>=8 then`);
  push(`        bits=bits-8`);
  push(`        local sh=1`);
  push(`        for _=1,bits do sh=sh*2 end`);
  push(`        oi=oi+1`);
  push(`        out[oi]=${X}.floor(acc/sh)%256`);
  push(`        acc=acc%sh`);
  push(`      end`);
  push(`    end`);
  push(`  end`);
  push(`  return out,oi`);
  push(`end`);

  // LZSS inflate (mirror of lzssCompress)
  push(`${X}.lz=function(arr,len)`);
  push(`  local out,oi={},0`);
  push(`  local win={}`);
  push(`  for i=1,${LZ_WINDOW} do win[i]=0 end`);
  push(`  local wp=1`);
  push(`  local i=1`);
  push(`  while i<=len do`);
  push(`    local fl=arr[i] i=i+1`);
  push(`    for bit=0,7 do`);
  push(`      if i>len then break end`);
  push(`      local m=1`);
  push(`      for _=1,bit do m=m*2 end`);
  push(`      if fl%(m*2)>=m then`);
  push(`        local c=arr[i] i=i+1`);
  push(`        oi=oi+1 out[oi]=${X}.schar(c)`);
  push(`        win[wp]=c wp=wp%${LZ_WINDOW}+1`);
  push(`      else`);
  push(`        if i+1>len then break end`);
  push(`        local b1=arr[i] local b2=arr[i+1] i=i+2`);
  push(`        local d=b1+(b2%16)*256+1`);
  push(`        local l=${X}.floor(b2/16)+${LZ_MIN_MATCH}`);
  push(`        local idx=wp-d-1`);
  push(`        for _=1,l do`);
  push(`          idx=idx+1`);
  push(`          if idx<=0 then idx=idx+${LZ_WINDOW} elseif idx>${LZ_WINDOW} then idx=idx-${LZ_WINDOW} end`);
  push(`          local c=win[idx]`);
  push(`          oi=oi+1 out[oi]=${X}.schar(c)`);
  push(`          win[wp]=c wp=wp%${LZ_WINDOW}+1`);
  push(`        end`);
  push(`      end`);
  push(`    end`);
  push(`  end`);
  push(`  return ${X}.tconcat(out)`);
  push(`end`);

  // byte array -> string
  push(`${X}.bytes=function(arr,from,to)`);
  push(`  local t={}`);
  push(`  for i=from,to do t[#t+1]=${X}.schar(arr[i]) end`);
  push(`  return ${X}.tconcat(t)`);
  push(`end`);

  /* ---- response ---- */
  push(`${X}.react=function(code)`);
  push(`  if ${X}.report then pcall(${X}.report,code) end`);
  push(`  if ${X}.mode==2 then`);
  push(`    error(${X}.emsg,0)`);
  push(`  elseif ${X}.mode==3 then`);
  push(`    local s=0`);
  push(`    while true do s=s+1 end`);
  push(`  elseif ${X}.mode==4 then`);
  push(`    local f=${X}.ld(${luaQuote(`local ${name().slice(1)}=nil return ${name().slice(1)}()`)},"")`);
  push(`    if ${X}.type(f)=="function" then pcall(f) end`);
  push(`  end`);
  push(`  ${X}.fatal=true`);
  push(`end`);

  /* ---- env logging ---- */
  if (envLogging) {
    const probeList = ENV_PROBE_APIS.map(luaQuote).join(",");
    push(`${X}.probes={${probeList}}`);
    push(`${X}.collect=function(code)`);
    push(`  local r={}`);
    push(`  r.v="4.0"`);
    push(`  r.pid=${X}.pid`);
    push(`  r.sid=${X}.sid`);
    push(`  r.code=code or 0`);
    push(`  r.flags=${X}.flags`);
    push(`  r.lua=_VERSION`);
    push(`  local idf=${X}.rawget(${X}.env,"identifyexecutor") or ${X}.rawget(${X}.env,"getexecutorname")`);
    push(`  if ${X}.type(idf)=="function" then`);
    push(`    local ok,a,b=${X}.pcall(idf)`);
    push(`    if ok then r.exec=tostring(a)..(b and ("|"..tostring(b)) or "") end`);
    push(`  end`);
    push(`  local g=${X}.rawget(_G,"game")`);
    push(`  if g then`);
    push(`    local ok,pid=${X}.pcall(function() return g.PlaceId end)`);
    push(`    if ok then r.place=pid end`);
    push(`    local ok2,jid=${X}.pcall(function() return g.JobId end)`);
    push(`    if ok2 then r.job=jid end`);
    push(`  end`);
    push(`  local apis={}`);
    push(`  for i=1,#${X}.probes do`);
    push(`    apis[${X}.probes[i]]=(${X}.type(${X}.rawget(${X}.env,${X}.probes[i]))~="nil")`);
    push(`  end`);
    push(`  r.apis=apis`);
    push(`  return r`);
    push(`end`);

    push(`${X}.emit=function(tbl)`);
    if (opts.envLogConsole) {
      push(`  pcall(function()`);
      push(`    local line="VertexShield|"..tostring(tbl.pid).."|"..tostring(tbl.code).."|flags="..#${X}.flags`);
      push(`    local pr=rawget(_G,"printconsole") or rawget(_G,"consoleprint") or print`);
      push(`    if ${X}.type(pr)=="function" then pr(line) end`);
      push(`  end)`);
    }
    const webhook = (opts.webhookUrl || "").trim();
    if (webhook) {
      push(`  pcall(function()`);
      push(`    local g=${X}.rawget(_G,"game")`);
      push(`    local enc=nil`);
      push(`    if g then`);
      push(`      local hs=g:GetService("HttpService")`);
      push(`      if hs then enc=hs:JSONEncode(tbl) end`);
      push(`    end`);
      push(`    if not enc then return end`);
      push(`    local cands={}`);
      push(`    cands[#cands+1]=${X}.rawget(${X}.env,"request")`);
      push(`    cands[#cands+1]=${X}.rawget(${X}.env,"http_request")`);
      push(`    local ht=${X}.rawget(${X}.env,"http")`);
      push(`    if ${X}.type(ht)=="table" then cands[#cands+1]=ht.request end`);
      push(`    local sy=${X}.rawget(${X}.env,"syn")`);
      push(`    if ${X}.type(sy)=="table" then cands[#cands+1]=sy.request end`);
      push(`    for i=1,#cands do`);
      push(`      if ${X}.type(cands[i])=="function" then`);
      push(`        pcall(cands[i],{Url=${luaQuote(webhook)},Method="POST",Headers={["Content-Type"]="application/json"},Body=enc})`);
      push(`        return`);
      push(`      end`);
      push(`    end`);
      push(`    if g then`);
      push(`      local hs=g:GetService("HttpService")`);
      push(`      if hs and hs.PostAsync then pcall(function() hs:PostAsync(${luaQuote(webhook)},enc,Enum and Enum.HttpContentType and Enum.HttpContentType.ApplicationJson or nil) end) end`);
      push(`    end`);
      push(`  end)`);
    }
    push(`end`);

    push(`${X}.report=function(code)`);
    push(`  local ok,tbl=${X}.pcall(${X}.collect,code)`);
    push(`  if ok and ${X}.type(tbl)=="table" then ${X}.emit(tbl) end`);
    push(`end`);
  } else {
    push(`${X}.report=nil`);
  }

  /* ---- environment verification (shared by boot + watchdog) ---- */
  const CORE_PRIMITIVES: [string, number][] = [
    [`${X}.sbyte`, 41],
    [`${X}.schar`, 42],
    [`${X}.tconcat`, 43],
    [`${X}.pcall`, 44],
    [`${X}.type`, 45],
    [`${X}.tonumber`, 46],
    [`${X}.ld`, 47],
    [`${X}.srep`, 48],
    [`${X}.floor`, 49],
    [`${X}.ssub`, 50],
  ];

  push(`${X}.verify=function()`);
  push(`  local before=#${X}.flags`);
  if (antiHook) {
    // Every primitive the loader relies on must still be a native closure.
    // Hooked replacements (hookfunction / newcclosure wrappers) show up as
    // user Lua functions and are what "dump on string.char" tricks use.
    push(`  local cl={${CORE_PRIMITIVES.map(([ref, code]) => `{${ref},${code}}`).join(",")}}`);
    push(`  for i=1,#cl do`);
    push(`    if ${X}.native(cl[i][1])==false then ${X}.flag(cl[i][2]) end`);
    push(`  end`);
    checkCount += CORE_PRIMITIVES.length;
  }
  push(`  return #${X}.flags>before`);
  push(`end`);

  /* ---------------- 5. payload chunks ---------------- */

  push(`${X}.C={}`);
  for (const item of emission) push(`${X}.C[${item.key}]=${luaQuote(item.piece)}`);

  /* ---------------- 6. pipeline blocks ---------------- */

  const blocks: Block[] = [];
  const block = (body: string[]) => {
    blocks.push({ body });
    return blocks.length - 1;
  };

  const junkLine = () =>
    `local ${name()}=${rndInt(rnd, 1000, 99999)}+${rndInt(rnd, 1, 999)}`;

  // B0 — reentrancy guard + baseline env verification
  {
    const body: string[] = [];
    if (opts.reentrancyGuard) {
      const marker = name();
      body.push(`if ${X}.rawget(_G,${luaQuote(marker)})~=nil then ${X}.react(11) else rawset(_G,${luaQuote(marker)},${X}.sid) end`);
    }
    if (antiHook) {
      body.push(`if ${X}.verify() then ${X}.react(12) return end`);
    }
    body.push(junkLine());
    block(body);
  }

  // B1 — anti-dump probes
  if (antiDump) {
    const body: string[] = [];
    if (hardened) {
      // a tracer/debug hook installed on the running thread is how dumpers
      // capture the decrypted chunk
      body.push(`if ${X}.hasdbg and ${X}.type(${X}.dbg.gethook)=="function" then`);
      body.push(`  local ok,h=${X}.pcall(${X}.dbg.gethook)`);
      body.push(`  if ok and h~=nil then ${flag(61)} end`);
      body.push(`end`);
      // wrapped execution (extra frames) is typical of dump harnesses
      body.push(`if ${X}.hasdbg and ${X}.type(${X}.dbg.getinfo)=="function" then`);
      body.push(`  local lvl=0`);
      body.push(`  while lvl<64 do`);
      body.push(`    local ok,inf=${X}.pcall(${X}.dbg.getinfo,lvl+1)`);
      body.push(`    if not ok or inf==nil then break end`);
      body.push(`    lvl=lvl+1`);
      body.push(`  end`);
      body.push(`  if lvl>${maxDepth} then ${flag(63)} end`);
      body.push(`end`);
    }
    // a frozen / rewinding clock defeats timing checks
    body.push(`if ${X}.type(${X}.clock)=="function" then`);
    body.push(`  local ok,a=${X}.pcall(${X}.clock)`);
    body.push(`  local spin=0`);
    body.push(`  for i=1,1500 do spin=spin+i end`);
    body.push(`  local ok2,b=${X}.pcall(${X}.clock)`);
    body.push(`  if (not ok) or (not ok2) or ${X}.type(a)~="number" or ${X}.type(b)~="number" or b<a then ${flag(62)} end`);
    body.push(`end`);
    if (paranoid) {
      // dump/decompile tooling present in the environment
      body.push(`local dl={${DUMP_APIS.map(luaQuote).join(",")}}`);
      body.push(`for i=1,#dl do if ${X}.rawget(${X}.env,dl[i])~=nil then ${X}.flag(70+i) end end`);
      checkCount += 1;
    }
    body.push(`if #${X}.flags>0 then ${X}.react(60) return end`);
    block(body);
  }

  // B2 — hook framework / env divergence probes
  if (antiHook && paranoid) {
    const body: string[] = [];
    body.push(`local hl={${HOOK_APIS.map(luaQuote).join(",")}}`);
    body.push(`for i=1,#hl do if ${X}.rawget(${X}.env,hl[i])~=nil then ${X}.flag(100+i) end end`);
    checkCount += 1;
    body.push(`local rf=${X}.rawget(_G,"getrenv")`);
    body.push(`if ${X}.type(rf)=="function" then`);
    body.push(`  local ok,r=${X}.pcall(rf)`);
    body.push(`  if ok and ${X}.type(r)=="table" then`);
    body.push(`    if ${X}.rawget(r,"string")~=string then ${flag(131)} end`);
    body.push(`    if ${X}.rawget(r,"table")~=table then ${flag(132)} end`);
    body.push(`    if ${X}.rawget(r,"math")~=math then ${flag(133)} end`);
    body.push(`    if ${X}.rawget(r,"loadstring")~=${X}.ld then ${flag(134)} end`);
    body.push(`  end`);
    body.push(`end`);
    body.push(`if ${X}.type(${X}.gmt)=="function" then`);
    body.push(`  local m=${X}.gmt(string)`);
    body.push(`  if ${X}.type(m)=="table" and m.__index~=nil and m.__index~=string then ${flag(135)} end`);
    body.push(`end`);
    body.push(`if #${X}.flags>0 then ${X}.react(130) return end`);
    block(body);
  }

  // B3 — reassemble ciphertext from shuffled chunks
  {
    const body: string[] = [];
    body.push(`${X}.keys={}`);
    body.push(`local ki=0`);
    body.push(`for tok in ${X}.gmatch(${X}.order,"([^,]+)") do`);
    body.push(`  local v=${X}.tonumber(tok)`);
    body.push(`  if v then ki=ki+1 ${X}.keys[ki]=v-${X}.om end`);
    body.push(`end`);
    body.push(`local buf={}`);
    body.push(`for i=1,#${X}.keys do buf[i]=${X}.C[${X}.keys[i]] end`);
    body.push(`${X}.ct=${X}.tconcat(buf)`);
    body.push(junkLine());
    block(body);
  }

  // B4 — ciphertext integrity
  {
    const body: string[] = [];
    body.push(`local h1,h2=${X}.hash(${X}.ct)`);
    body.push(`if h1~=${X}.e1 or h2~=${X}.e2 then ${X}.react(81) return end`);
    block(body);
  }

  // B5 — base64 decode
  {
    const body: string[] = [];
    body.push(`${X}.cb,${X}.cn2=${X}.b64(${X}.ct)`);
    body.push(`if ${X}.cn2<2 then ${X}.react(82) return end`);
    block(body);
  }

  // B6 — decrypt (reverse CBC chain)
  {
    const body: string[] = [];
    body.push(`local prev=${X}.iv`);
    body.push(`for i=1,${X}.cn2 do`);
    body.push(`  local c=${X}.cb[i]`);
    body.push(
      `  local ks=(${X}.a1+(((i-1)%256)*${X}.a2)+(((i-1)%${X}.a3)*7)+(${X}.floor((i-1)/64)%256))%256`,
    );
    body.push(`  local v=(c-ks-prev+512)%256`);
    body.push(`  ${X}.cb[i]=v`);
    body.push(`  prev=c`);
    body.push(`end`);
    block(body);
  }

  // B7 — inverse affine scatter
  {
    const body: string[] = [];
    // inverse of the affine scatter: plain[i] = cipher[(i*A + B) mod n]
    body.push(`local out={}`);
    body.push(`local d=${X}.sb%${X}.cn2`);
    body.push(`local step=${X}.sa%${X}.cn2`);
    body.push(`for i=1,${X}.cn2 do`);
    body.push(`  out[i]=${X}.cb[d+1]`);
    body.push(`  d=d+step`);
    body.push(`  if d>=${X}.cn2 then d=d-${X}.cn2 end`);
    body.push(`end`);
    body.push(`${X}.pt=out`);
    block(body);
  }

  // B8 — inflate
  {
    const body: string[] = [];
    body.push(`local fl=${X}.pt[1]`);
    body.push(`if fl==1 then`);
    body.push(`  local tmp={}`);
    body.push(`  for i=2,${X}.cn2 do tmp[i-1]=${X}.pt[i] end`);
    body.push(`  ${X}.src=${X}.lz(tmp,${X}.cn2-1)`);
    body.push(`elseif fl==0 then`);
    body.push(`  ${X}.src=${X}.bytes(${X}.pt,2,${X}.cn2)`);
    body.push(`else`);
    body.push(`  ${X}.react(83) return`);
    body.push(`end`);
    block(body);
  }

  // B9 — plaintext integrity + immediate wipe of intermediate state
  {
    const body: string[] = [];
    body.push(`if #${X}.src~=${X}.pl then ${X}.react(84) return end`);
    body.push(`local h1,h2=${X}.hash(${X}.src)`);
    body.push(`if h1~=${X}.p1 or h2~=${X}.p2 then ${X}.react(85) return end`);
    body.push(`${X}.ct=nil`);
    body.push(`for k in ${X}.pairs(${X}.C) do ${X}.C[k]=nil end`);
    body.push(`${X}.keys=nil ${X}.order=nil ${X}.cb=nil ${X}.pt=nil`);
    block(body);
  }

  // B10 — load, verify chunk identity, execute
  {
    const body: string[] = [];
    body.push(`local fn,err=${X}.ld(${X}.src,${X}.cn)`);
    body.push(`if ${X}.type(fn)~="function" then ${X}.src=nil ${X}.react(91) return end`);
    body.push(`if ${X}.hasdbg and ${X}.type(${X}.dbg.getinfo)=="function" then`);
    body.push(`  local ok,inf=${X}.pcall(${X}.dbg.getinfo,fn,"S")`);
    body.push(`  if ok and ${X}.type(inf)=="table" and inf.source and inf.source~=${X}.cn then ${X}.flag(92) end`);
    body.push(`end`);
    body.push(`local ok,rerr=${X}.pcall(fn)`);
    body.push(`${X}.src=nil fn=nil`);
    body.push(`if #${X}.flags>0 and not ok then ${X}.react(92) return end`);
    body.push(`if not ok then ${X}.react(93) return end`);
    block(body);
  }

  // B11 — watchdog
  if (watchdog) {
    const body: string[] = [];
    const interval = paranoid ? rndInt(rnd, 3, 6) : rndInt(rnd, 8, 15);
    body.push(`local tsk=${X}.rawget(_G,"task")`);
    body.push(`local sched=nil waitf=nil`);
    body.push(`if ${X}.type(tsk)=="table" and ${X}.type(tsk.spawn)=="function" then sched=tsk.spawn waitf=tsk.wait end`);
    body.push(`if sched==nil then local sp=${X}.rawget(_G,"spawn") local wt=${X}.rawget(_G,"wait") if ${X}.type(sp)=="function" and ${X}.type(wt)=="function" then sched=sp waitf=wt end end`);
    body.push(`if sched and waitf then`);
    body.push(`  pcall(function()`);
    body.push(`    sched(function()`);
    body.push(`      while true do`);
    body.push(`        waitf(${interval})`);
    body.push(`        if ${X}.verify() then ${X}.react(95) break end`);
    body.push(`      end`);
    body.push(`    end)`);
    body.push(`  end)`);
    body.push(`end`);
    block(body);
  }

  // B12 — optional clean-run report
  if (envLogging) {
    block([`pcall(${X}.report,0)`]);
  }

  /* ---------------- 7. emit blocks + dispatcher ---------------- */

  blocks.forEach((b, i) => {
    push(`${X}.f${i}=function()`);
    b.body.forEach((line) => push(`  ${line}`));
    push(`end`);
  });

  if (flatten) {
    // randomized state machine with decoy states
    const stateIds = shuffle(
      Array.from({ length: blocks.length }, (_, i) => rndInt(rnd, 1000 + i * 7, 99999)),
      rnd,
    ).map((v, i) => Math.max(1, v + i * 137));
    const uniqueStates = Array.from(new Set(stateIds));
    while (uniqueStates.length < blocks.length) uniqueStates.push(rndInt(rnd, 100000, 999999));
    const exitState = rndInt(rnd, 100000, 999999) + blocks.length * 1000;

    const decoyCount = paranoid ? 4 : hardened ? 2 : 1;
    const decoys: { id: number; lines: string[] }[] = [];
    for (let i = 0; i < decoyCount; i++) {
      const target = uniqueStates[rndInt(rnd, 0, uniqueStates.length - 1)];
      decoys.push({
        id: exitState + 1 + i,
        lines: [
          `local ${name()}=${rndInt(rnd, 10000, 99999)}`,
          `${X}.j${i}=(${rndInt(rnd, 1, 999)}*${rndInt(rnd, 2, 97)})%${rndInt(rnd, 1000, 5000)}`,
          `st=${target}`,
        ],
      });
    }

    push(`local st=${uniqueStates[0]}`);
    push(`while true do`);
    const entries: { id: number; lines: string[] }[] = blocks.map((_, i) => ({
      id: uniqueStates[i],
      lines: [
        `${X}.f${i}()`,
        `if ${X}.fatal then st=${exitState} else st=${
          i + 1 < blocks.length ? uniqueStates[i + 1] : exitState
        } end`,
      ],
    }));
    const all = shuffle([...entries, ...decoys], rnd);
    all.forEach((entry, idx) => {
      push(`${idx === 0 ? "if" : "elseif"} st==${entry.id} then`);
      entry.lines.forEach((line) => push(`  ${line}`));
    });
    push(`elseif st==${exitState} then`);
    push(`  break`);
    push(`else`);
    push(`  break`);
    push(`end`);
    push(`end`);
  } else {
    blocks.forEach((_, i) => {
      push(`${X}.f${i}()`);
      push(`if ${X}.fatal then return end`);
    });
  }

  push(`${X}.C=nil ${X}.alpha=nil ${X}.rev=nil`);
  push("end");

  const out = L.join("\n");

  (protectLua as unknown as { lastStats?: LuaProtectionStats }).lastStats = {
    sourceBytes: srcBytes.length,
    compressedBytes: body.length,
    cipherChars: cipherText.length,
    chunks: pieces.length,
    ratio: srcBytes.length > 0 ? out.length / srcBytes.length : 0,
    checks: checkCount,
  };

  return out;
}

export function getProtectionStats(): LuaProtectionStats | undefined {
  return (protectLua as unknown as { lastStats?: LuaProtectionStats }).lastStats;
}
