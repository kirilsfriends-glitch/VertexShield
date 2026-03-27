import JavaScriptObfuscator from "javascript-obfuscator";

export function obfuscateCode(code: string): string {
  if (!code || code.trim().length === 0) return "";
  
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
    // If it's not valid JS (like Lua), we just return the original code
    // without logging a scary error to the console
    return code;
  }
}
