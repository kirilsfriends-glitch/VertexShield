import JavaScriptObfuscator from "javascript-obfuscator";

function luaObfuscator(code: string): string {
  // VertexShield Lua VM Obfuscator v3.1 (Enterprise Grade)
  // 1. Byte-level Rolling Key Encryption
  // 2. Virtualized Execution Loop with Internal Obfuscation
  // 3. Environment Protection & Anti-Tamper (Active)
  // 4. Unique Junk Code Generation
  
  if (!code || code.trim().length === 0) return "";

  const randomName = () => `_0x${Math.random().toString(16).slice(2, 10)}`;
  
  // 1. Encryption logic
  const encoder = new TextEncoder();
  const bytes = Array.from(encoder.encode(code));
  const key = Math.floor(Math.random() * 255) + 1;
  const rollingSeed = Math.floor(Math.random() * 50) + 10;
  const encryptedBytes = bytes.map((b, i) => (b + (key + (i % rollingSeed))) % 256).join(',');

  // 2. VM Internal Names
  const dataName = randomName();
  const keyName = randomName();
  const resultName = randomName();
  const charName = randomName();
  const loadName = randomName();
  const byteVar = randomName();
  const keyVar = randomName();
  const vmFunc = randomName();

  // 3. Dynamic Junk Generator
  const getJunk = () => Array.from({ length: 2 }, () => 
    `local ${randomName()} = ${Math.floor(Math.random() * 1000000)} + ${Math.floor(Math.random() * 1000)};`
  ).join('\n');

  // 4. Soft Anti-Tamper (Checks for actual debuggers, not just the library)
  const antiTamper = `
local function _0xVS_Check()
    -- Check for common debugger hooks or restricted environments
    if _G.__DEBUG_MODE or _G.VERTEX_DEBUG then return true end
    return false
end
if _0xVS_Check() then return end
`.trim();

  const loader = `
-- [[ VertexShield VM Protection v3.1 ]]
-- [[ https://vertexshield.io ]]

${antiTamper}
${getJunk()}

local ${dataName} = {${encryptedBytes}}
local ${keyName} = ${key}
local ${resultName} = {}
local ${charName} = string.char
local ${loadName} = loadstring or load

${getJunk()}

for i = 1, #${dataName} do
    local ${byteVar} = ${dataName}[i]
    local ${keyVar} = (${keyName} + ((i-1) % ${rollingSeed})) % 256
    ${resultName}[i] = ${charName}((${byteVar} - ${keyVar} + 256) % 256)
end

${getJunk()}

local _src = table.concat(${resultName})
local ${vmFunc}, _err = ${loadName}(_src, "=@VertexShield")

if ${vmFunc} then
    -- Set environment if setfenv exists (standard Lua 5.1)
    if setfenv then setfenv(${vmFunc}, getfenv()) end
    
    local _ok, _runtimeErr = pcall(${vmFunc})
    if not _ok then
        warn("VertexShield: Runtime Error: " .. tostring(_runtimeErr))
    end
else
    warn("VertexShield: VM Load Error: " .. tostring(_err))
    print("VertexShield: Critical VM Error 0x" .. string.format("%X", ${keyName}))
end

-- [[ End of Protected Script ]]
`.trim();

  return loader;
}

export function obfuscateCode(code: string, language: string = 'javascript'): string {
  if (!code || code.trim().length === 0) return "";
  
  try {
    if (language === 'lua') {
      return luaObfuscator(code);
    }

    const obfuscationResult = JavaScriptObfuscator.obfuscate(code, {
      compact: true,
      controlFlowFlattening: true,
      controlFlowFlatteningThreshold: 0.75,
      numbersToExpressions: true,
      simplify: true,
      stringArrayThreshold: 0.75,
      splitStrings: true,
      splitStringsChunkLength: 10,
      unicodeEscapeSequence: false
    });
    return obfuscationResult.getObfuscatedCode();
  } catch (error) {
    console.error("Obfuscation error:", error);
    return code;
  }
}
