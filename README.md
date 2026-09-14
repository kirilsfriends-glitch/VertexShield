<div align="center">
<img width="1200" height="475" alt="GHBanner" src="https://github.com/user-attachments/assets/0aa67016-6eaf-458a-adb2-6e31a0763ed6" />
</div>

# Run and deploy your AI Studio app

This contains everything you need to run your app locally.

View your app in AI Studio: https://ai.studio/apps/a2aa08f8-9420-4912-a9f4-a96496b1ee9a

## Run Locally

**Prerequisites:**  Node.js


1. Install dependencies:
   `npm install`
2. Set the `GEMINI_API_KEY` in [.env.local](.env.local) to your Gemini API key
3. Run the app:
   `npm run dev`

## Code Obfuscation (Client-Side)

Scripts are obfuscated **in the browser** before being uploaded. The original plaintext is **never** sent to or
stored by VertexShield.

- **JavaScript / TypeScript** — `javascript-obfuscator` (control-flow flattening, string array + base64, self-defending wrapper, debug protection)
- **Lua** — **VertexShield Protection v4**, a purpose-built layered runtime protector (next section)
- **Output** — the `obfuscatedContent` field on the Firestore document
- **Raw content** — kept in `content` for the owner's editing view only, never exposed publicly

## Lua Protection (VertexShield Protection v4)

Lua sources are not merely renamed and scrambled. They are wrapped in a loader that decrypts, verifies and then
executes the original source at runtime, with a check at every stage against the tooling normally pointed at a
protected script: a static decompiler, a `loadstring` hook, a memory dumper.

```
source ──▶ LZSS ──▶ byte scatter ──▶ chained cipher ──▶ base64 chunks ──▶ loader
           (compress)  (positional)    (per chunk key)    (random alphabet)   (below)
```

### Loader pipeline

| Stage | What it does |
| --- | --- |
| Compression | Custom LZSS (4 KiB window). A typical script shrinks to ~40% of its size, so the loader is often *smaller* than the source it protects |
| Positional scatter | Payload bytes are permuted with an affine map, so a dumped ciphertext is not even in the right order |
| Encryption | Each chunk gets its own key; every byte is chained to the previous ciphertext byte (CBC-style) and mixed with a keystream |
| Encoding | Base64 over a per-document shuffled alphabet with no quote, backslash or bracket characters, split into randomly sized chunks emitted in random order |
| Control flow | The loader body is flattened into a randomized `while true do if st == N then ...` state machine with unreachable decoy states |
| Structure | Blocks live as closures in a namespace table, so no Lua chunk needs more than one upvalue (5.1 caps upvalues at 60) |

### Anti-dump checks (`antiDump`, on by default)

- **Ciphertext checksum** — twin rolling hashes over the whole payload, recomputed on every run. A single patched byte
  changes both hashes and execution stops before anything is decrypted.
- **Plaintext checksum** — after decoding, the decompressed source is hashed again before `load()` ever sees it.
- **Loaded chunk identity** — the function returned by `load()` is inspected with `debug.getinfo`/`debug.info` and
  compared against the expected chunk name, catching a wrapped or intercepted loader.
- **Debugger detection** — an active `debug.sethook` trace hook aborts the run (decompilers and hook frameworks set one).
- **Environment sanity** — call-stack depth and monotonic clock checks flag emulated or instrumented runtimes.
- **Ephemeral payload** — the chunk table, the base64 string and the decoded source are wiped right after the function
  is created, so there is nothing left to grep for later.

### Anti-hook checks (`antiHook`, on by default)

Before any payload data is touched, the loader verifies that the primitives it depends on (`string.char`,
`loadstring`, `table.concat`, `string.byte`, …) are still native closures. A hooked or monkey-patched function reports
a non-native type and the run stops, so an interceptor never sees the decrypted source.

### Protection levels

| Level | Adds |
| --- | --- |
| `standard` | Checksums, chunk identity, loaded-source identity, native-primitive scan, re-entrancy guard |
| `hardened` | + debugger hook detection, stack depth check, monotonic clock check, source wipe |
| `paranoid` | + scan for dump/decompiler APIs (`dumpstring`, `getscriptbytecode`, `decompile`, …), hook-framework APIs (`hookfunction`, `hookmetamethod`, `checkcaller`, …) and `_G` vs `getgenv` divergence |

> Paranoid mode flags *capability*, not intent. Most executors legitimately expose `getgenv`/`hookfunction`, so start
> on `hardened` and escalate deliberately.

### Response modes

What the loader does when a check trips: `silent` (default — stop, no payload), `error` (fail with a believable
"runtime error", no mention of protection), `corrupt` (execute a broken decoy chunk), `hang` (lock the thread),
`report` (keep running, collect the triggered flag codes).

### Environment logging (off by default)

`envLogging` takes a technical snapshot of the runtime — executor name, engine version, which dump/hook APIs are
present, the flag codes that tripped, place/job id. **No personal data is collected.** Reports go to an optional
webhook (`webhookUrl`) and/or a one-line console echo (`envLogConsole`); with neither configured the snapshot is
discarded. Flag codes are documented in `src/utils/luaProtector.ts` (`FLAG_*` constants, 41–135).

### Usage

```ts
import { obfuscateCode } from "./utils/obfuscator";

const loader = obfuscateCode(luaSource, "lua", {
  level: "hardened",      // standard | hardened | paranoid
  antiDump: true,         // payload + plaintext checksums, debugger/stack/clock checks
  antiHook: true,         // native primitive verification
  envLogging: false,      // opt-in runtime snapshot
  envLogConsole: false,   // one-line console echo of the snapshot
  webhookUrl: "",         // optional report transport
  responseMode: "silent", // silent | error | corrupt | hang | report
  watchdog: false,        // re-verify the environment on a task.spawn loop
});
```

`getProtectionStats(loader)` returns the emitted loader's `sourceBytes`, `compressedBytes`, `cipherChars`, `chunks`,
`ratio` (loader size / source size) and `checks` (number of anti-tamper checks actually emitted).

> The loader needs `loadstring`/`load` at runtime, so it targets executors. The `/script/:id` endpoint serves the
> protected source as `text/plain` for `loadstring(game:HttpGet(...))()`.

### Tests

`npm test` executes every generated loader in **fengari** (Lua 5.3 on JS) and asserts the payload comes back
byte-identical, tampered ciphertext is refused, hooked primitives are caught, a pristine environment raises no false
positives, and the emitted LZSS decoder round-trips the compressor on text, repetitive, random and tiny inputs.
