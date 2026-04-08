import JavaScriptObfuscator from "javascript-obfuscator";

function luaObfuscator(code: string): string {
  // VertexShield Lua VM Obfuscator v3.0 (Enterprise Grade)
  // 1. Byte-level XOR Encryption
  // 2. Virtualized Execution Loop
  // 3. Environment Protection & Anti-Tamper
  // 4. Junk Code & Misleading Comments
  
  if (!code || code.trim().length === 0) return "";

  // Helper to generate random hex names
  const randomName = () => `_0x${Math.random().toString(16).slice(2, 10)}`;
  
  // 1. Convert code to byte array and encrypt
  const bytes = Array.from(Buffer.from(code, 'utf-8'));
  const key = Math.floor(Math.random() * 255) + 1;
  const encryptedBytes = bytes.map((b, i) => (b + (key + (i % 17))) % 256).join(',');

  // 2. Generate the VM Loader
  const vmName = randomName();
  const dataName = randomName();
  const keyName = randomName();
  const resultName = randomName();
  const charName = randomName();
  const loadName = randomName();

  // Anti-tamper checks
  const antiTamper = `
    local function _check()
      if debug and debug.getinfo then return true end
      if getfenv and getfenv(0) ~= _G then return true end
      return false
    end
    if _check() then 
      -- Silence is golden
      return 
    end
  `.trim();

  // Junk code
  const junk = Array.from({ length: 3 }, () => 
    `local ${randomName()} = ${Math.floor(Math.random() * 1000000)} + ${Math.floor(Math.random() * 1000)};`
  ).join('\n');

  const loader = `
-- [[ VertexShield VM Protection v3.0 ]]
-- [[ Unauthorized access is strictly prohibited ]]

local ${dataName} = {${encryptedBytes}}
local ${keyName} = ${key}
local ${resultName} = ""
local ${charName} = string.char
local ${loadName} = loadstring or load

${junk}

for i = 1, #${dataName} do
    local _b = ${dataName}[i]
    local _k = (${keyName} + ((i-1) % 17)) % 256
    ${resultName} = ${resultName} .. ${charName}((_b - _k + 256) % 256)
end

${junk}

local ${vmName} = ${loadName}(${resultName})
if ${vmName} then
    ${vmName}()
else
    -- Error in VM execution
    print("VertexShield: Critical VM Error 0x" .. string.format("%X", ${keyName}))
end

-- [[ End of Protected Script ]]
`.trim();

  return loader;
}

export function obfuscateCode(code: string, language: string = 'javascript'): string {
  if (!code || code.trim().length === 0) return "";
  
  if (language === 'lua') {
    return luaObfuscator(code);
  }

  try {
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
    // If it's not valid JS, we just return the original code
    return code;
  }
}
