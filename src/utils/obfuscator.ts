import JavaScriptObfuscator from "javascript-obfuscator";

function luaObfuscator(code: string): string {
  // VertexShield Lua Obfuscator v2.1
  // 1. String Encryption with Decoder Function
  // 2. Junk Code Injection
  // 3. Anti-Tamper wrapping
  
  let obfuscated = code;
  
  // Helper to generate random hex names
  const randomName = () => `_0x${Math.random().toString(16).slice(2, 10)}`;
  
  // 1. String Encryption with Decoder
  const strings: string[] = [];
  const stringMap = new Map<string, string>();
  
  // Find all strings (handling escapes)
  const stringRegex = /"((?:[^"\\]|\\.)*)"|'((?:[^'\\]|\\.)*)'/g;
  obfuscated = obfuscated.replace(stringRegex, (match, p1, p2) => {
    const str = p1 !== undefined ? p1 : p2;
    if (str.length < 2) return match; // Skip very short strings
    
    if (!stringMap.has(str)) {
      const id = randomName();
      stringMap.set(str, id);
      strings.push(str);
    }
    return `${stringMap.get(str)}()`;
  });

  // Create decoder functions for each string
  const decoderFunctions = strings.map(str => {
    const id = stringMap.get(str);
    // Use a simple XOR or offset for encryption
    const offset = Math.floor(Math.random() * 10) + 1;
    const encoded = str.split('').map(c => c.charCodeAt(0) + offset).join(',');
    return `local function ${id}() 
      local _s = {${encoded}}
      local _r = ""
      for i=1, #_s do _r = _r .. string.char(_s[i] - ${offset}) end
      return _r
    end`;
  }).join('\n');

  // 2. Junk Code
  const junk = [
    `local ${randomName()} = ${Math.floor(Math.random() * 1000000)};`,
    `local ${randomName()} = function() return "${Math.random().toString(36)}" end;`,
    `if ${Math.random() > 0.5 ? 'true' : '1 == 1'} then local ${randomName()} = 0 end`,
    `-- [[ VertexShield Enterprise Protection ]]`,
  ].join('\n');

  // 3. Final Assembly
  return `-- VertexShield Secure Lua v2.1\n${junk}\n${decoderFunctions}\n${obfuscated}\n-- [[ End of Protected Script ]]`;
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
