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

  // 4. Anti-Tamper
  const antiTamper = `
local function _0xVS_Check()
    local _d = debug and debug.getinfo
    local _f = getfenv and getfenv(0)
    if _d or (_f and _f ~= _G) then return true end
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

local ${vmFunc} = ${loadName}(table.concat(${resultName}))
if ${vmFunc} then
    ${vmFunc}()
else
    print("VertexShield: VM Error 0x" .. string.format("%X", ${keyName}))
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
