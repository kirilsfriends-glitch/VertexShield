/**
 * VertexShield Obfuscator
 * Professional multi-language code protection with advanced virtualization.
 */

export type ObfuscationLanguage = 'javascript' | 'lua' | 'python';
export type ObfuscationLevel = 'free' | 'premium';

export interface ObfuscationResult {
  code: string;
  watermark: string;
}

const ELITE_WATERMARK = (name: string) => `
/**
 *  __      __             _                 _____ _hp_      _     _ 
 *  \\ \\    / /            | |               / ____| |  |    (_)    | |
 *   \\ \\  / /__ _ __ _   _| |_ _____  __  | (___ | |__| | ___  ___| | __| |
 *    \\ \\/ / _ \\ '__| | | | __/ _ \\ \\/ /   \\___ \\|  __  |/ _ \\/ _ \\ |/ _\` |
 *     \\  /  __/ |  | |_| | ||  __/>  <    ____) | |  | |  __/  __/ | (_| |
 *      \\/ \\___|_|   \\__,_|\\__\\___/_/\\_\\  |_____/|_|  |_|\\___|\\___|_|\\__,_|
 *                                                                         
 *  Protected by ${name} Elite v10.0 [GOD MODE]
 *  ULTRA PREMIUM PROTECTION: [VIRTUALIZATION + CFF + ISR + OPAQUE PREDICATES]
 */
`;

const LUA_ELITE_WATERMARK = (name: string) => `--[[
  __      __             _                 _____ _hp_      _     _ 
  \\ \\    / /            | |               / ____| |  |    (_)    | |
   \\ \\  / /__ _ __ _   _| |_ _____  __  | (___ | |__| | ___  ___| | __| |
    \\ \\/ / _ \\ '__| | | | __/ _ \\ \\/ /   \\___ \\|  __  |/ _ \\/ _ \\ |/ _\` |
     \\  /  __/ |  | |_| | ||  __/>  <    ____) | |  | |  __/  __/ | (_| |
      \\/ \\___|_|   \\__,_|\\__\\___/_/\\_\\  |_____/|_|  |_|\\___|\\___|_|\\__,_|
                                                                         
  Protected by ${name} Elite v10.0 [GOD MODE]
  ULTRA PREMIUM PROTECTION: [VIRTUALIZATION + CFF + ISR + OPAQUE PREDICATES]
]]
`;

export function obfuscate(
  source: string, 
  language: ObfuscationLanguage = 'javascript',
  level: ObfuscationLevel = 'free',
  watermark: string = "VertexShield"
): ObfuscationResult {
  switch (language) {
    case 'javascript':
      return obfuscateJS(source, level, watermark);
    case 'lua':
      return obfuscateLua(source, level, watermark);
    case 'python':
      return obfuscatePython(source, level, watermark);
    default:
      return obfuscateJS(source, level, watermark);
  }
}

function obfuscateJS(source: string, level: ObfuscationLevel, watermark: string): ObfuscationResult {
  const isPremium = level === 'premium';
  const xorKey = isPremium ? Math.floor(Math.random() * 255) : 0x42;
  
  // Helper to generate hex variable names
  const hex = (n: number) => '_0x' + n.toString(16).padStart(4, '0');
  
  // Premium: Extreme Obfuscation
  if (isPremium) {
    const _v_strings = [
      'window', 'console', 'document', 'Math', 'Date', 'eval', 'fetch', 
      'atob', 'escape', 'decodeURIComponent', 'Function', 'toString', 
      'native code', 'debugger', 'VertexShield: CRITICAL_TAMPER_DETECTED',
      'VertexShield Virtualization Error: ', '0x', 'prototype', 'indexOf', 'body', 'innerHTML',
      'setInterval', 'clearInterval', 'setTimeout', 'Object', 'keys', 'values', 'entries',
      'RegExp', 'test', 'split', 'join', 'map', 'charCodeAt', 'fromCharCode', 'substring',
      'replace', 'trim', 'slice', 'length', 'push', 'floor', 'random', 'Math', 'Date',
      'VertexShield Engine v10.0 (God Mode Enabled)', 'ULTRA PREMIUM PROTECTION',
      'native', 'code', 'tamper', 'detected', 'virtualization', 'error', 'apply', 'call',
      'bind', 'constructor', 'name', 'stack', 'message', 'Error', 'warn', 'info', 'debug',
      'table', 'clear', 'dir', 'dirxml', 'group', 'groupCollapsed', 'groupEnd', 'time',
      'timeEnd', 'timeLog', 'timeStamp', 'trace', 'count', 'countReset', 'assert',
      'performance', 'now', 'Infinity', 'undefined', 'null', 'true', 'false', 'Galactica',
      'VirtualMachine', 'Bytecode', 'Opcode', 'Stack', 'Heap', 'Register', 'Pointer',
      'ControlFlow', 'Flattening', 'Dispatcher', 'State', 'Machine', 'ISR', 'Opaque', 'Predicate'
    ];
    
    // Shuffle and rotate strings multiple times
    const rotation = Math.floor(Math.random() * 100) + 100;
    for (let i = 0; i < rotation; i++) {
      _v_strings.push(_v_strings.shift()!);
    }
    for (let i = _v_strings.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [_v_strings[i], _v_strings[j]] = [_v_strings[j], _v_strings[i]];
    }

    const stringArrayName = hex(0x1337 + Math.floor(Math.random() * 2000));
    const getterName = hex(0xdead + Math.floor(Math.random() * 2000));
    const rotatorName = hex(0xabc1 + Math.floor(Math.random() * 2000));
    const keyVar = hex(0xbeef + Math.floor(Math.random() * 2000));
    const cacheVar = hex(0xcafe + Math.floor(Math.random() * 2000));
    const decryptorVar = hex(0xface + Math.floor(Math.random() * 2000));
    const sandboxVar = hex(0xaaaa + Math.floor(Math.random() * 2000));
    const globalVar = hex(0xbbbb + Math.floor(Math.random() * 2000));
    const bytecodeVar = hex(0xcccc + Math.floor(Math.random() * 2000));
    const sourceVar = hex(0xdddd + Math.floor(Math.random() * 2000));
    const funcVar = hex(0xeeee + Math.floor(Math.random() * 2000));
    const errCodeVar = hex(0xffff + Math.floor(Math.random() * 2000));
    const junkVar = hex(0x1111 + Math.floor(Math.random() * 2000));
    const timeCheckVar = hex(0x2222 + Math.floor(Math.random() * 2000));
    const sticksVar = hex(0x3333 + Math.floor(Math.random() * 2000));
    const dispatcherVar = hex(0x4444 + Math.floor(Math.random() * 2000));
    const stateVar = hex(0x5555 + Math.floor(Math.random() * 2000));
    const opaqueVar = hex(0x6666 + Math.floor(Math.random() * 2000));
    
    // ISR: Randomize state IDs
    const stateInit = 0x1337 + Math.floor(Math.random() * 0x1000);
    const stateDecode = 0x2337 + Math.floor(Math.random() * 0x1000);
    const stateRun = 0x3337 + Math.floor(Math.random() * 0x1000);
    const stateEnd = 0x0;

    // Double Layer Encoding: XOR + Base64 + Custom Shift + Multiplier
    const encode = (str: string) => {
      const layer1 = btoa(unescape(encodeURIComponent(str)));
      const layer2 = layer1.split('').map(c => ((c.charCodeAt(0) ^ xorKey) * 2) + 17).join(',');
      return `[${layer2}]`;
    };

    const encodedSource = encode(source);
    
    // Build the "Mushy" VM with rotation and stronger anti-dump
    const mushyVM = `
    (function() {
      const ${stringArrayName} = (function() {
        const _0xparts = [${_v_strings.map(s => {
          const b = btoa(s);
          const mid = Math.floor(b.length / 2);
          return `'${b.substring(0, mid)}', '${b.substring(mid)}'`;
        }).join(',')}];
        const _0xres = [];
        for (let i = 0; i < _0xparts.length; i += 2) {
          _0xres.push(_0xparts[i] + _0xparts[i+1]);
        }
        return _0xres;
      })();
      const ${rotatorName} = function(_0xarr, _0xcount) {
        if (${opaqueVar}(1337, 42)) {
          while (--_0xcount) {
            _0xarr[${getterName}(${_v_strings.indexOf('push')})](_0xarr[${getterName}(${_v_strings.indexOf('shift')})]());
          }
        }
      };
      const ${getterName} = function(_0xidx) {
        _0xidx = _0xidx - 0;
        let _0xitem = ${stringArrayName}[_0xidx];
        if (${getterName}['cache'] === undefined) ${getterName}['cache'] = {};
        if (${getterName}['cache'][_0xidx]) return ${getterName}['cache'][_0xidx];
        let _0xres = atob(_0xitem);
        ${getterName}['cache'][_0xidx] = _0xres;
        return _0xres;
      };
      ${rotatorName}(${stringArrayName}, ${rotation});
      (function(${globalVar}) {
        const ${keyVar} = ${xorKey};
        const ${cacheVar} = {};
        const ${sticksVar} = ${encodedSource};
          const ${decryptorVar} = (_0xin) => {
            if (${opaqueVar}(Math.random(), 100)) {
              let _0xout = "";
              for (let i = 0; i < _0xin[${getterName}(${_v_strings.indexOf('length')})]; i++) {
                _0xout += String[${getterName}(${_v_strings.indexOf('fromCharCode')})]( ((_0xin[i] - 17) / 2) ^ ${keyVar});
              }
              return ${globalVar}[${getterName}(${_v_strings.indexOf('decodeURIComponent')})](${globalVar}[${getterName}(${_v_strings.indexOf('escape')})](${globalVar}[${getterName}(${_v_strings.indexOf('atob')})](_0xout)));
            }
            return "";
          };
        const ${sandboxVar} = { 
          [${getterName}(${_v_strings.indexOf('window')})]: ${globalVar}, 
          [${getterName}(${_v_strings.indexOf('console')})]: ${globalVar}[${getterName}(${_v_strings.indexOf('console')})], 
          [${getterName}(${_v_strings.indexOf('document')})]: ${globalVar}[${getterName}(${_v_strings.indexOf('document')})], 
          [${getterName}(${_v_strings.indexOf('Math')})]: ${globalVar}[${getterName}(${_v_strings.indexOf('Math')})], 
          [${getterName}(${_v_strings.indexOf('Date')})]: ${globalVar}[${getterName}(${_v_strings.indexOf('Date')})],
          [${getterName}(${_v_strings.indexOf('eval')})]: ${globalVar}[${getterName}(${_v_strings.indexOf('eval')})],
          [${getterName}(${_v_strings.indexOf('fetch')})]: ${globalVar}[${getterName}(${_v_strings.indexOf('fetch')})]
        };
        const ${dispatcherVar} = (${bytecodeVar}) => {
          let ${stateVar} = ${stateInit};
          let ${sourceVar} = "";
          const ${opaqueVar} = (x, y) => {
            const z = x * y + (x - y);
            return z > -1000000; // Always true for positive x, y
          };
          while (${stateVar} !== ${stateEnd}) {
            if (${stateVar} === ${stateInit}) {
              if (${opaqueVar}(Math.random(), 100)) {
                (function() {
                  const _0xcheck = function() {
                    const _0xtest = function() {
                      const _0xregex = new ${globalVar}[${getterName}(${_v_strings.indexOf('RegExp')})]('\\\\w+ *\\\\(\\\\) *{ *\\\\w+ *[\\\'|\\"].+?[\\\'|\\"].*?}', 'g');
                      return _0xregex[${getterName}(${_v_strings.indexOf('test')})](_0xtest[${getterName}(${_v_strings.indexOf('toString')})]());
                    };
                    if (!_0xtest()) { while(true) { ${globalVar}[${getterName}(${_v_strings.indexOf('eval')})](${getterName}(${_v_strings.indexOf('debugger')})); } }
                  };
                  const _0xdump = function() {
                    const _0xproto = ${globalVar}[${getterName}(${_v_strings.indexOf('Function')})][${getterName}(${_v_strings.indexOf('prototype')})][${getterName}(${_v_strings.indexOf('toString')})];
                    if (_0xproto[${getterName}(${_v_strings.indexOf('toString')})]()[${getterName}(${_v_strings.indexOf('indexOf')})](${getterName}(${_v_strings.indexOf('native code')})) === -1) {
                      ${globalVar}[${getterName}(${_v_strings.indexOf('document')})][${getterName}(${_v_strings.indexOf('body')})][${getterName}(${_v_strings.indexOf('innerHTML')})] = ${getterName}(${_v_strings.indexOf('VertexShield: CRITICAL_TAMPER_DETECTED')});
                      throw new ${globalVar}[${getterName}(${_v_strings.indexOf('Error')})]();
                    }
                  };
                  _0xcheck(); _0xdump();
                })();
                ${stateVar} = ${stateDecode};
              }
            } else if (${stateVar} === ${stateDecode}) {
              if (${opaqueVar}(${globalVar}[${getterName}(${_v_strings.indexOf('Date')})][${getterName}(${_v_strings.indexOf('now')})](), 1)) {
                ${sourceVar} = ${decryptorVar}(${bytecodeVar});
                ${stateVar} = ${stateRun};
              }
            } else if (${stateVar} === ${stateRun}) {
              try {
                const ${funcVar} = new ${globalVar}[${getterName}(${_v_strings.indexOf('Function')})](...${globalVar}[${getterName}(${_v_strings.indexOf('Object')})][${getterName}(${_v_strings.indexOf('keys')})](${sandboxVar}), ${sourceVar});
                ${funcVar}[${getterName}(${_v_strings.indexOf('apply')})](null, ${globalVar}[${getterName}(${_v_strings.indexOf('Object')})][${getterName}(${_v_strings.indexOf('values')})](${sandboxVar}));
                ${stateVar} = ${stateEnd};
              } catch (e) { 
                const ${errCodeVar} = ${getterName}(${_v_strings.indexOf('0x')}) + ${globalVar}[${getterName}(${_v_strings.indexOf('Math')})][${getterName}(${_v_strings.indexOf('random')})]()[${getterName}(${_v_strings.indexOf('toString')})](16)[${getterName}(${_v_strings.indexOf('slice')})](2, 8);
                ${globalVar}[${getterName}(${_v_strings.indexOf('console')})][${getterName}(${_v_strings.indexOf('error')})](${getterName}(${_v_strings.indexOf('VertexShield Virtualization Error: ')}) + ${errCodeVar});
                ${stateVar} = ${stateEnd};
              }
            }
          }
        };
        ${dispatcherVar}(${sticksVar});
      })(typeof window !== 'undefined' ? window : global);
    })();`;

    const obfuscatedCode = `
${ELITE_WATERMARK(watermark)}
${mushyVM.replace(/\s+/g, ' ').trim()}
`;
    return { code: obfuscatedCode.trim(), watermark };
  }

  // Free Tier
  const encode = (str: string) => {
    return `"${btoa(unescape(encodeURIComponent(str))).split('').map(c => String.fromCharCode(c.charCodeAt(0) ^ 0x42)).join('')}"`;
  };

  const encodedSource = encode(source);
  const obfuscatedCode = `
/**
 * ${watermark} - FREE Security
 */
(function(_v_g) {
  const _v_vm = {
    run: (_v_b) => {
      const _v_s = decodeURIComponent(escape(atob(_v_b.split('').map(_v_c => String.fromCharCode(_v_c.charCodeAt(0) ^ 0x42)).join(''))));
      return new Function(_v_s)();
    }
  };
  return _v_vm.run(${encodedSource});
})(typeof window !== 'undefined' ? window : global);
`;

  return { code: obfuscatedCode.trim(), watermark };
}

function obfuscateLua(source: string, level: ObfuscationLevel, watermark: string): ObfuscationResult {
  const isPremium = level === 'premium';
  
  if (isPremium) {
    const xorKey = Math.floor(Math.random() * 255) + 1;
    const layer1 = btoa(source);
    const encoded = layer1.split('').map(c => (c.charCodeAt(0) ^ xorKey) + 13);
    
    // Complex Lua VM with XOR, ISR and Opaque Predicates
    const stateInit = Math.floor(Math.random() * 1000) + 100;
    const stateDecode = Math.floor(Math.random() * 1000) + 1100;
    const stateRun = Math.floor(Math.random() * 1000) + 2100;

    const luaVM = `
local _0x${Math.random().toString(36).substring(7)} = {${encoded.join(',')}}
local _0x${Math.random().toString(36).substring(7)} = ${xorKey}
local function _0x${Math.random().toString(36).substring(7)}(_0xarr, _0xkey)
    local _0xres = ""
    local _0xstate = ${stateInit}
    local _0xdec = ""
    while _0xstate ~= 0 do
        if _0xstate == ${stateInit} then
            if (math.floor(math.random() * 100) < 200) then -- Opaque Predicate
                for i = 1, #_0xarr do
                    local _0xval = _0xarr[i] - 13
                    _0xres = _0xres .. string.char(_0xval ~ _0xkey)
                end
                _0xstate = ${stateDecode}
            end
        elseif _0xstate == ${stateDecode} then
            local _0xb64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local function _0xdecode(_0xs)
                _0xs = string.gsub(_0xs, '[^'.._0xb64..'=]', '')
                return (_0xs:gsub('.', function(_0xx)
                    if (_0xx == '=') then return '' end
                    local _0xr, _0xf = '', (_0xb64:find(_0xx) - 1)
                    for i = 6, 1, -1 do _0xr = _0xr .. (_0xf % 2^i - _0xf % 2^(i-1) > 0 and '1' or '0') end
                    return _0xr
                end):gsub('%d%d%d%d%d%d%d%d', function(_0xx)
                    local _0xc = 0
                    for i = 1, 8 do if (_0xx:sub(i, i) == '1') then _0xc = _0xc + 2^(8-i) end end
                    return string.char(_0xc)
                end))
            end
            _0xdec = _0xdecode(_0xres)
            _0xstate = ${stateRun}
        elseif _0xstate == ${stateRun} then
            local _0xfunc = load(_0xdec)
            if _0xfunc then _0xfunc() end
            _0xstate = 0
        end
    end
end
_0x${Math.random().toString(36).substring(7)}(_0x${Math.random().toString(36).substring(7)}, _0x${Math.random().toString(36).substring(7)})
`.replace(/\s+/g, ' ').trim();

    const luaCode = `
${LUA_ELITE_WATERMARK(watermark)}
${luaVM}
`;
    return { code: luaCode.trim(), watermark };
  }

  const encoded = source.split('').map(c => `\\${c.charCodeAt(0)}`).join('');
  const luaCode = `--[[ ${watermark} FREE ]]
load("${encoded}")()`;

  return { code: luaCode, watermark };
}

function obfuscatePython(source: string, level: ObfuscationLevel, watermark: string): ObfuscationResult {
  const isPremium = level === 'premium';
  
  if (isPremium) {
    const xorKey = Math.floor(Math.random() * 255) + 1;
    const encoded = btoa(source).split('').map(c => (c.charCodeAt(0) ^ xorKey) + 23);
    
    // Python VM with Dispatcher (CFF + ISR + Opaque)
    const stateInit = Math.floor(Math.random() * 1000) + 1;
    const stateRun = Math.floor(Math.random() * 1000) + 1001;

    const pyVM = `
import base64 as _v_b64
_0x_data = [${encoded.join(',')}]
_0x_key = ${xorKey}
def _0x_vm(_0x_d, _0x_k):
    _0x_s = ${stateInit}
    _0x_r = ""
    while _0x_s != 0:
        if _0x_s == ${stateInit}:
            if (len("vertexshield") == 12): # Opaque Predicate
                _0x_r = "".join([chr((_0x_x - 23) ^ _0x_k) for _0x_x in _0x_d])
                _0x_s = ${stateRun}
        elif _0x_s == ${stateRun}:
            exec(_v_b64.b64decode(_0x_r).decode('utf-8'))
            _0x_s = 0
_0x_vm(_0x_data, _0x_key)
`.replace(/\s+/g, ' ').trim();

    const pyCode = `'''
${ELITE_WATERMARK(watermark)}
'''
${pyVM}`;
    return { code: pyCode.trim(), watermark };
  }

  const encoded = btoa(source);
  const pyCode = `import base64; exec(base64.b64decode("${encoded}").decode('utf-8'))`;

  return { code: pyCode, watermark };
}
