import JavaScriptObfuscator from "javascript-obfuscator";
import { protectLua, type LuaProtectionOptions } from "./luaProtector";

export type {
  LuaProtectionOptions,
  LuaProtectionStats,
  ProtectionLevel,
  ResponseMode,
} from "./luaProtector";
export { getProtectionStats } from "./luaProtector";

/**
 * VertexShield code obfuscation entry point.
 *
 * - Lua  -> layered protector (compression + stream cipher + scatter +
 *           shuffled base64 chunks) wrapped in a self-defending, control-flow
 *           flattened loader with anti-dump / anti-hook / env-logging layers.
 * - JS/TS -> javascript-obfuscator pipeline.
 */
export function obfuscateCode(
  code: string,
  language: string = "javascript",
  options: LuaProtectionOptions = {},
): string {
  if (!code || code.trim().length === 0) return "";

  try {
    if (language === "lua") {
      return protectLua(code, options);
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
      unicodeEscapeSequence: false,
    });
    return obfuscationResult.getObfuscatedCode();
  } catch (error) {
    console.error("Obfuscation error:", error);
    return code;
  }
}
