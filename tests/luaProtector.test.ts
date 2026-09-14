/**
 * End-to-end verification for the Lua protector.
 *
 * Every test executes the *generated* loader inside a real Lua VM (fengari,
 * Lua 5.3) and asserts on what actually happened at runtime — round trips,
 * tamper detection, hooked-primitive detection, response modes and reporting.
 *
 * Run with: npm test
 */
import { test } from "node:test";
import assert from "node:assert/strict";
import * as fengari from "fengari";
import { protectLua, lzssCompress, HASH_M1, HASH_M2, HASH_R1, HASH_R2 } from "../src/utils/luaProtector";

const { lua, lauxlib, lualib, to_luastring } = fengari;

interface RunResult {
  ok: boolean;
  error: string;
  marker: string | null;
  printed: string;
}

const HARNESS = `
__PRINTED = ""
print = function(...)
  local t = {}
  for i = 1, select('#', ...) do t[i] = tostring((select(i, ...))) end
  __PRINTED = __PRINTED .. table.concat(t, " ") .. "\\n"
end
`;

function runLua(code: string, pre?: string): RunResult {
  const L = lauxlib.luaL_newstate();
  lualib.luaL_openlibs(L);

  if (lauxlib.luaL_dostring(L, to_luastring(HARNESS)) !== 0) {
    throw new Error("harness failed: " + lua.lua_tojsstring(L, -1));
  }
  if (pre) {
    if (lauxlib.luaL_dostring(L, to_luastring(pre)) !== 0) {
      throw new Error("pre failed: " + lua.lua_tojsstring(L, -1));
    }
  }

  const status = lauxlib.luaL_dostring(L, to_luastring(code));
  const error = status === 0 ? "" : String(lua.lua_tojsstring(L, -1) ?? "unknown error");

  lua.lua_getglobal(L, to_luastring("__MARK"));
  const marker = lua.lua_isstring(L, -1) ? String(lua.lua_tojsstring(L, -1)) : null;
  lua.lua_pop(L, 1);

  lua.lua_getglobal(L, to_luastring("__PRINTED"));
  const printed = lua.lua_isstring(L, -1) ? String(lua.lua_tojsstring(L, -1)) : "";
  lua.lua_pop(L, 1);

  lua.lua_close(L);
  return { ok: status === 0, error, marker, printed };
}

const SAMPLE = `-- demo payload
local function fib(n)
  if n < 2 then return n end
  return fib(n - 1) + fib(n - 2)
end
local sum = 0
for i = 1, 12 do sum = sum + fib(i) end
__MARK = "ok:" .. tostring(sum) .. ":" .. tostring(6 * 7)
`;

/* ------------------------------------------------------------------ */

test("generated loader decrypts and executes the original payload", () => {
  const out = protectLua(SAMPLE, { seed: 1337 });
  const res = runLua(out);
  assert.equal(res.ok, true, `loader errored: ${res.error}`);
  assert.equal(res.marker, "ok:376:42");
});

test("every protection level produces a working loader", () => {
  for (const level of ["standard", "hardened", "paranoid"] as const) {
    for (const flatten of [true, false]) {
      const out = protectLua(SAMPLE, { level, flatten, seed: 4242 });
      const res = runLua(out);
      assert.equal(res.ok, true, `level=${level} flatten=${flatten}: ${res.error}`);
      assert.equal(res.marker, "ok:376:42", `level=${level} flatten=${flatten}`);
    }
  }
});

test("response mode 'report' still runs the payload", () => {
  const out = protectLua(SAMPLE, { responseMode: "report", seed: 99 });
  const res = runLua(out);
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:376:42");
});

test("payload survives quotes, brackets, unicode and newlines", () => {
  const nasty = [
    `local s1 = "double \\" quote"`,
    `local s2 = 'single \\' quote'`,
    `local s3 = [[long [==[bracket]==] text]]`,
    `local s4 = "back\\\\slash and \\t tab"`,
    `local s5 = "юникод: привет мир 日本語 🛡️"`,
    `local s6 = string.rep("]=]=", 5)`,
    `__MARK = "ok:" .. tostring(#s1 + #s2 + #s3 + #s4 + #s5 + #s6)`,
  ].join("\n");
  const out = protectLua(nasty, { seed: 777 });
  const res = runLua(out);
  assert.equal(res.ok, true, res.error);
  const expected = runLua(nasty);
  assert.equal(expected.ok, true, expected.error);
  assert.equal(res.marker, expected.marker);
});

test("empty and whitespace-only input is a no-op", () => {
  assert.equal(protectLua(""), "");
  assert.equal(protectLua("   \n\t "), "");
});

test("tiny inputs that cannot compress still round trip", () => {
  const out = protectLua("__MARK='ok:42'", { seed: 5 });
  const res = runLua(out);
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:42");
});

test("large payloads round trip (compression path)", () => {
  const big = `local t = {}\n` + `for i = 1, 3000 do t[i] = "row " .. tostring(i) .. " payload padding payload" end\n__MARK = "ok:" .. tostring(#t)\n`;
  const out = protectLua(big, { seed: 31337 });
  const res = runLua(out);
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:3000");
});

test("compression actually shrinks repetitive payloads", () => {
  const repetitive = new Uint8Array(20000).fill(65); // "AAAA..."
  const packed = lzssCompress(repetitive);
  assert.ok(packed.length < repetitive.length / 5, `only shrank to ${packed.length}`);
});

test("same seed is deterministic, different seeds are not", () => {
  const a = protectLua(SAMPLE, { seed: 1 });
  const b = protectLua(SAMPLE, { seed: 1 });
  const c = protectLua(SAMPLE, { seed: 2 });
  assert.equal(a, b);
  assert.notEqual(a, c);
});

test("generated loader contains no readable trace of the source", () => {
  const secret = "SUPER_SECRET_TOKEN_9f3a";
  const out = protectLua(`local token = "${secret}"\n__MARK = "ok:1"`, { seed: 11 });
  assert.equal(out.includes(secret), false, "plaintext leaked into the loader");
  assert.equal(out.includes("SUPER_SECRET"), false);
});

/* ------------------------- anti-dump -------------------------------- */

test("anti-dump: tampered ciphertext blocks execution (silent)", () => {
  const out = protectLua(SAMPLE, { seed: 8080, responseMode: "silent" });
  const tampered = flipOnePayloadChar(out);
  assert.notEqual(tampered, out, "could not tamper with the payload");
  const res = runLua(tampered);
  assert.equal(res.marker, null, "tampered payload must not execute");
});

test("anti-dump: tampered ciphertext raises a decoy error in error mode", () => {
  const out = protectLua(SAMPLE, { seed: 8081, responseMode: "error" });
  const tampered = flipOnePayloadChar(out);
  const res = runLua(tampered);
  assert.equal(res.ok, false, "expected the loader to abort with an error");
  assert.match(res.error, /attempt to/);
  assert.equal(res.marker, null);
});

test("anti-dump: corrupt mode aborts without executing the payload", () => {
  const out = protectLua(SAMPLE, { seed: 8082, responseMode: "corrupt" });
  const res = runLua(flipOnePayloadChar(out));
  assert.equal(res.marker, null);
});

test("anti-dump: payload checksum is validated before load()", () => {
  // Removing a chunk entirely must be caught by the ciphertext hash.
  const out = protectLua(SAMPLE, { seed: 8083 });
  const chunkLine = out.split("\n").find((l) => /^_\w+\.C\[\d+\]="[!-~]{40,}"/.test(l.trim()));
  assert.ok(chunkLine, "no chunk line found to tamper with");
  const stripped = out.replace(chunkLine!, `${chunkLine!.split("=")[0]}="AAAA"`);
  const res = runLua(stripped);
  assert.equal(res.marker, null, "dropped chunk must not execute");
});

test("anti-dump: a debug trace hook is detected", () => {
  const out = protectLua(SAMPLE, { seed: 8084, level: "hardened", responseMode: "silent" });
  const res = runLua(out, `debug.sethook(function() end, "lcr")`);
  assert.equal(res.marker, null, "traced execution must be blocked");
});

/* ------------------------- anti-hook -------------------------------- */

test("anti-hook: hooked string.char blocks execution", () => {
  const out = protectLua(SAMPLE, { seed: 9090, responseMode: "silent" });
  const res = runLua(
    out,
    `local real = string.char
string.char = function(...) return real(...) end`,
  );
  assert.equal(res.marker, null, "hooked primitive must be detected");
});

test("anti-hook: hooked loadstring blocks execution", () => {
  const out = protectLua(SAMPLE, { seed: 9091, responseMode: "silent" });
  const res = runLua(
    out,
    `local real = load
load = function(...) return real(...) end
loadstring = load`,
  );
  assert.equal(res.marker, null, "hooked loader must be detected");
});

test("anti-hook: pristine environment is not a false positive", () => {
  const out = protectLua(SAMPLE, { seed: 9092, level: "paranoid" });
  const res = runLua(out);
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:376:42");
});

/* ------------------------- env logging ------------------------------ */

test("env logging: clean run reports to the console when enabled", () => {
  const out = protectLua(SAMPLE, {
    seed: 4321,
    envLogging: true,
    envLogConsole: true,
    scriptId: "paste123",
  });
  const res = runLua(out);
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:376:42");
  assert.match(res.printed, /VertexShield\|paste123\|0/);
});

test("env logging: a detection is reported with its flag code", () => {
  const out = protectLua(SAMPLE, {
    seed: 4322,
    envLogging: true,
    envLogConsole: true,
    responseMode: "silent",
    scriptId: "p42",
  });
  const res = runLua(
    out,
    `local real = string.char
string.char = function(...) return real(...) end`,
  );
  assert.equal(res.marker, null);
  assert.match(res.printed, /VertexShield\|p42\|12/);
});

test("env logging: webhook transport is wired when a URL is provided", () => {
  const out = protectLua(SAMPLE, {
    seed: 4323,
    envLogging: true,
    webhookUrl: "https://example.invalid/vertex",
  });
  assert.match(out, /https:\/\/example\.invalid\/vertex/);
  const res = runLua(out); // no http transport in a bare VM: must not throw
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:376:42");
});

test("env logging is opt-in: no reporter is emitted by default", () => {
  const out = protectLua(SAMPLE, { seed: 4324 });
  assert.equal(out.includes(".collect="), false);
  const res = runLua(out);
  assert.equal(res.marker, "ok:376:42");
});

/* ------------------------- structure -------------------------------- */

test("flattened loader hides sequential structure in a state machine", () => {
  const out = protectLua(SAMPLE, { seed: 2468, flatten: true });
  assert.match(out, /while true do/);
  assert.match(out, /elseif st==\d+ then/);
});

test("non-flattened loader still executes correctly", () => {
  const out = protectLua(SAMPLE, { seed: 2469, flatten: false });
  assert.equal(/elseif st==\d+ then/.test(out), false, "state dispatcher should be absent");
  assert.match(out, /\.f0\(\)\nif _\w+\.fatal then return end/);
  const res = runLua(out);
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:376:42");
});

test("watchdog installs only when requested", () => {
  const withDog = protectLua(SAMPLE, { seed: 111, watchdog: true });
  const without = protectLua(SAMPLE, { seed: 111, watchdog: false, level: "standard" });
  assert.match(withDog, /spawn/);
  assert.equal(without.includes("tsk.spawn"), false);
  // a watchdog must not break a VM without task/spawn
  const res = runLua(withDog);
  assert.equal(res.marker, "ok:376:42", res.error);
});

test("re-entrancy guard blocks a second run in the same environment", () => {
  const out = protectLua(SAMPLE, { seed: 222, reentrancyGuard: true });
  const L = lauxlib.luaL_newstate();
  lualib.luaL_openlibs(L);
  lauxlib.luaL_dostring(L, to_luastring(HARNESS));
  assert.equal(lauxlib.luaL_dostring(L, to_luastring(out)), 0);
  lua.lua_getglobal(L, to_luastring("__MARK"));
  assert.equal(String(lua.lua_tojsstring(L, -1)), "ok:376:42");
  lua.lua_pop(L, 1);
  // second execution in the same VM must be refused
  lauxlib.luaL_dostring(L, to_luastring("__MARK = nil"));
  lauxlib.luaL_dostring(L, to_luastring(out));
  lua.lua_getglobal(L, to_luastring("__MARK"));
  const second = lua.lua_isstring(L, -1) ? String(lua.lua_tojsstring(L, -1)) : null;
  lua.lua_close(L);
  assert.equal(second, null, "second run should have been refused");
});

test("multi-chunk payloads reassemble correctly across many seeds", () => {
  // regression: the chunk order list must follow logical, not emission, order
  const medium = Array.from({ length: 200 }, (_, i) => `rows[${i + 1}] = { id = ${i}, tag = "tag-${i}-${i * 7}" }`).join("\n");
  const src = `local rows = {}\n${medium}\n__MARK = "ok:multi:" .. tostring(#rows)\n`;
  let maxChunks = 0;
  for (let seed = 1; seed <= 25; seed++) {
    const out = protectLua(src, { seed });
    const chunkCount = (out.match(/\.C\[\d+\]=/g) || []).length;
    maxChunks = Math.max(maxChunks, chunkCount);
    assert.ok(chunkCount >= 2, `seed ${seed}: expected a multi-chunk payload, got ${chunkCount}`);
    const res = runLua(out);
    assert.equal(res.ok, true, `seed ${seed}: ${res.error}`);
    assert.equal(res.marker, "ok:multi:200", `seed ${seed} failed to reassemble ${chunkCount} chunks`);
  }
  assert.ok(maxChunks >= 8, `expected some seed to need many chunks, max was ${maxChunks}`);
});

test("emitted LZSS decoder inflates what the compressor produced", () => {
  const cases: Record<string, Uint8Array> = {
    text: new TextEncoder().encode(SAMPLE.repeat(20)),
    repetitive: new TextEncoder().encode("abcdefgh".repeat(5000)),
    random: Uint8Array.from({ length: 4096 }, () => Math.floor(Math.random() * 256)),
    runs: new TextEncoder().encode("a".repeat(300) + "b".repeat(300) + "ab".repeat(400)),
    tiny: new TextEncoder().encode("hi!"), // >= LZ_MIN_MATCH, so still LZSS framed
  };

  // pull the decoder straight out of a generated loader so the *emitted* Lua
  // is what gets exercised, not a copy of it
  const loader = protectLua("__MARK = 1", { seed: 6 });
  const ctx = (loader.match(/local (_\w+) = \{\}/) as RegExpMatchArray)[1];
  const lines = loader.split("\n");
  const start = lines.findIndex((l) => l.startsWith(`${ctx}.lz=function(arr,len)`));
  assert.ok(start >= 0, "lz decoder not found in loader");
  let end = start + 1;
  while (lines[end] !== "end") end++;
  const decoder = lines.slice(start, end + 1).join("\n");

  for (const [label, data] of Object.entries(cases)) {
    const packed = lzssCompress(data);
    const arr = Array.from(packed).join(",");
    // digest inside the VM: raw bytes must not travel through JS string decoding
    let h1 = 7;
    let h2 = 11;
    for (let i = 0; i < data.length; i++) {
      h1 = (h1 * HASH_R1 + data[i]) % HASH_M1;
      h2 = (h2 * HASH_R2 + data[i] * 3 + 7) % HASH_M2;
    }
    const L = lauxlib.luaL_newstate();
    lualib.luaL_openlibs(L);
    const harness = `
local ${ctx} = { schar = string.char, floor = math.floor, tconcat = table.concat }
${decoder}
local arr = {${arr}}
local s = ${ctx}.lz(arr, #arr)
local a,b = 7,11
for i = 1, #s do
  local c = string.byte(s, i)
  a = (a * ${HASH_R1} + c) % ${HASH_M1}
  b = (b * ${HASH_R2} + c * 3 + 7) % ${HASH_M2}
end
RES = string.format("%d %d %d", #s, a, b)
`;
    const status = lauxlib.luaL_dostring(L, to_luastring(harness));
    assert.equal(status, 0, `${label}: ${lua.lua_tojsstring(L, -1)}`);
    lua.lua_getglobal(L, to_luastring("RES"));
    const got = String(lua.lua_tojsstring(L, -1));
    lua.lua_close(L);
    assert.equal(got, `${data.length} ${h1} ${h2}`, `${label}: inflated output differs`);
  }
});

test("obfuscateCode routes lua to the protector and js to javascript-obfuscator", async () => {
  const { obfuscateCode } = await import("../src/utils/obfuscator");
  const luaOut = obfuscateCode(SAMPLE, "lua", { seed: 3 });
  assert.match(luaOut, /VertexShield Protection v4/);
  const res = runLua(luaOut);
  assert.equal(res.marker, "ok:376:42", res.error);

  const jsOut = obfuscateCode("var answer = 6 * 7;", "javascript");
  assert.notEqual(jsOut, "var answer = 6 * 7;");
  assert.ok(jsOut.length > 40, "js output looks unobfuscated");

  assert.equal(obfuscateCode("", "lua"), "");
});

test("protecting a 200 KiB script stays usable", () => {
  const big =
    "local rows = {}\n" +
    Array.from({ length: 6000 }, (_, i) => `rows[${i + 1}] = { id = ${i}, name = "row ${i}" }`).join("\n") +
    "\n__MARK = \"ok:big:\" .. tostring(#rows)\n";
  const t0 = Date.now();
  const out = protectLua(big, { seed: 555 });
  const genMs = Date.now() - t0;
  const t1 = Date.now();
  const res = runLua(out);
  const runMs = Date.now() - t1;
  assert.equal(res.ok, true, res.error);
  assert.equal(res.marker, "ok:big:6000");
  assert.ok(out.length < big.length * 3, `loader blew up to ${out.length} for ${big.length} bytes`);
  console.log(`      200KiB-ish payload: source=${big.length}B loader=${out.length}B gen=${genMs}ms run=${runMs}ms`);
});

/* ------------------------------------------------------------------ */

const PAYLOAD_CHARS = "!#$%&()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ^_abcdefghijklmnopqrstuvwxyz{|}~";

/** Flip a single character inside one of the emitted payload chunks. */
function flipOnePayloadChar(code: string): string {
  const lines = code.split("\n");
  for (let i = 0; i < lines.length; i++) {
    const m = /^(\s*_\w+\.C\[\d+\]=")([!-~]+)(")\s*$/.exec(lines[i]);
    if (!m) continue;
    const body = m[2];
    const idx = Math.floor(body.length / 2);
    const cur = body[idx];
    const replacement = PAYLOAD_CHARS[(PAYLOAD_CHARS.indexOf(cur) + 1) % PAYLOAD_CHARS.length];
    lines[i] = m[1] + body.slice(0, idx) + replacement + body.slice(idx + 1) + m[3];
    return lines.join("\n");
  }
  return code;
}
