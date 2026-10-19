const MONACO_CDN = 'https://cdn.jsdelivr.net/npm/monaco-editor@0.52.2/min/vs';
const INDENT = '    ';
const API_ENDPOINT = '/api/request.php';
const COOLDOWN_SECONDS = 8;

let editor = null;
let monacoReady = null;
let generateCooldown = false;

function showToast(message, type = 'error') {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.classList.remove('success');
    if (type === 'success') toast.classList.add('success');
    toast.classList.add('show');
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

function setActive(element, event) {
    if (event) event.preventDefault();
    document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
    element.classList.add('active');
}

function toggleTheme() {
    const currentTheme = document.body.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.body.setAttribute('data-theme', newTheme);

    if (window.monaco && editor) {
        window.monaco.editor.setTheme(newTheme === 'dark' ? 'luavault-dark' : 'luavault-light');
    }
}

function toggleDropdown() {
    document.getElementById('modelDropdown').classList.toggle('open');
    document.getElementById('actionDropdown').classList.remove('open');
}

function selectModel(modelName, tag, event) {
    if (event) event.stopPropagation();
    document.getElementById('selectedModelText').textContent = modelName;
    document.getElementById('modelDropdown').classList.remove('open');
    document.querySelectorAll('#modelDropdown .select-option').forEach(opt => opt.classList.remove('selected'));
    if (event && event.currentTarget) {
        event.currentTarget.classList.add('selected');
    }
}

function toggleActionDropdown() {
    document.getElementById('actionDropdown').classList.toggle('open');
    document.getElementById('modelDropdown').classList.remove('open');
}

function selectAction(actionName, event) {
    if (event) event.stopPropagation();
    document.getElementById('selectedActionText').textContent = actionName;
    document.getElementById('actionDropdown').classList.remove('open');
    document.querySelectorAll('#actionDropdown .select-option').forEach(opt => opt.classList.remove('selected'));
    if (event && event.currentTarget) {
        event.currentTarget.classList.add('selected');
    }
}

document.addEventListener('click', function (e) {
    const modelSelect = document.getElementById('modelSelect');
    if (modelSelect && !modelSelect.contains(e.target)) {
        document.getElementById('modelDropdown').classList.remove('open');
    }
    const actionSelect = document.getElementById('actionSelect');
    if (actionSelect && !actionSelect.contains(e.target)) {
        document.getElementById('actionDropdown').classList.remove('open');
    }
});

const promptInput = document.getElementById('promptInput');
const charCount = document.getElementById('charCount');

promptInput.addEventListener('input', function () {
    charCount.textContent = this.value.length;
});

function loadMonaco() {
    if (monacoReady) return monacoReady;
    monacoReady = new Promise((resolve, reject) => {
        if (window.monaco) return resolve(window.monaco);
        const loader = document.createElement('script');
        loader.src = MONACO_CDN + '/loader.js';
        loader.onload = () => {
            window.require.config({ paths: { vs: MONACO_CDN } });
            window.require(['vs/editor/editor.main'], () => resolve(window.monaco));
        };
        loader.onerror = () => reject(new Error('Failed to load Monaco'));
        document.head.appendChild(loader);
    });
    return monacoReady;
}

function defineThemes(monaco) {
    monaco.editor.defineTheme('luavault-dark', {
        base: 'vs-dark',
        inherit: true,
        rules: [
            { token: 'comment', foreground: '6b7280', fontStyle: 'italic' },
            { token: 'keyword', foreground: 'c586c0', fontStyle: 'bold' },
            { token: 'string', foreground: 'ce9178' },
            { token: 'number', foreground: 'b5cea8' },
            { token: 'type.identifier', foreground: '4ec9b0' },
            { token: 'identifier', foreground: '9cdcfe' }
        ],
        colors: {
            'editor.background': '#1a1a1a',
            'editor.foreground': '#f1f2f5',
            'editorLineNumber.foreground': '#4d525e',
            'editorLineNumber.activeForeground': '#22c55e',
            'editorCursor.foreground': '#22c55e',
            'editor.lineHighlightBackground': '#202020',
            'editor.selectionBackground': '#22c55e33'
        }
    });

    monaco.editor.defineTheme('luavault-light', {
        base: 'vs',
        inherit: true,
        rules: [
            { token: 'comment', foreground: '7a7f8a', fontStyle: 'italic' },
            { token: 'keyword', foreground: 'af00db', fontStyle: 'bold' },
            { token: 'string', foreground: 'a31515' },
            { token: 'number', foreground: '098658' },
            { token: 'type.identifier', foreground: '267f99' },
            { token: 'identifier', foreground: '001080' }
        ],
        colors: {
            'editor.background': '#ffffff',
            'editor.foreground': '#111111'
        }
    });
}

function extractUserFunctions(code) {
    const functions = new Map();
    const regexLocal = /\blocal\s+function\s+([A-Za-z_]\w*)\s*\(([^)]*)\)/g;
    const regexGlobal = /(^|[^.\w])function\s+([A-Za-z_]\w*)\s*\(([^)]*)\)/g;
    const regexMethod = /\bfunction\s+([A-Za-z_]\w*):([A-Za-z_]\w*)\s*\(([^)]*)\)/g;
    const regexDot = /\bfunction\s+([A-Za-z_]\w*)\.([A-Za-z_]\w*)\s*\(([^)]*)\)/g;

    let m;
    while ((m = regexLocal.exec(code)) !== null) {
        functions.set(m[1], { name: m[1], args: m[2].trim(), kind: 'local' });
    }
    while ((m = regexGlobal.exec(code)) !== null) {
        functions.set(m[2], { name: m[2], args: m[3].trim(), kind: 'global' });
    }
    while ((m = regexMethod.exec(code)) !== null) {
        const key = `${m[1]}:${m[2]}`;
        functions.set(key, { name: m[2], args: m[3].trim(), kind: 'method', owner: m[1] });
    }
    while ((m = regexDot.exec(code)) !== null) {
        const key = `${m[1]}.${m[2]}`;
        functions.set(key, { name: m[2], args: m[3].trim(), kind: 'dot', owner: m[1] });
    }

    return Array.from(functions.values());
}

function buildFunctionCallSuggestion(fn, S, SNIPPET, withRange) {
    const args = fn.args;
    let insertText;
    let detail;

    if (fn.kind === 'method') {
        insertText = `${fn.owner}:${fn.name}(${args ? '${1}' : ''})`;
        detail = `${fn.owner}:${fn.name}(${args || ''})`;
    } else if (fn.kind === 'dot') {
        insertText = `${fn.owner}.${fn.name}(${args ? '${1}' : ''})`;
        detail = `${fn.owner}.${fn.name}(${args || ''})`;
    } else {
        insertText = `${fn.name}(${args ? '${1}' : ''})`;
        detail = `${fn.name}(${args || ''})`;
    }

    return withRange({
        label: {
            label: fn.name,
            description: fn.kind === 'local' ? 'local function' : fn.kind === 'method' ? 'method' : 'function',
            detail: args ? `(${args})` : '()'
        },
        kind: S.Function,
        insertText,
        insertTextRules: SNIPPET,
        detail,
        documentation: `Calls the function \`${fn.name}\` defined in this file.`,
        sortText: '0_' + fn.name
    });
}

function registerLua(monaco) {
    if (registerLua.done) return;
    registerLua.done = true;

    monaco.languages.register({ id: 'lua' });

    monaco.languages.setMonarchTokensProvider('lua', {
        keywords: [
            'local', 'function', 'end', 'if', 'then', 'else', 'elseif', 'for', 'while', 'do',
            'return', 'break', 'nil', 'true', 'false', 'and', 'or', 'not', 'in', 'repeat', 'until'
        ],
        robloxGlobals: [
            'game', 'workspace', 'script', 'Instance', 'Vector3', 'CFrame', 'Color3', 'UDim2',
            'FindFirstChild', 'WaitForChild', 'GetService', 'Players', 'RunService', 'TweenService',
            'print', 'warn', 'error', 'wait', 'spawn', 'task', 'math', 'string', 'table', 'os',
            'Humanoid', 'HumanoidRootPart', 'Part', 'Model', 'Folder', 'Debris', 'HttpService',
            'ReplicatedStorage', 'ServerScriptService', 'ServerStorage', 'StarterGui', 'StarterPlayer',
            'pairs', 'ipairs', 'next', '_G'
        ],
        tokenizer: {
            root: [
                [/[a-zA-Z_]\w*/, {
                    cases: {
                        '@keywords': 'keyword',
                        '@robloxGlobals': 'type.identifier',
                        '@default': 'identifier'
                    }
                }],
                [/"([^"\\]|\\.)*$/, 'string.invalid'],
                [/"/, 'string', '@string_double'],
                [/'([^'\\]|\\.)*$/, 'string.invalid'],
                [/'/, 'string', '@string_single'],
                [/\d+/, 'number'],
                [/--.*$/, 'comment'],
                [/[{}()\[\]]/, '@brackets'],
                [/[=><!~?:&|+\-*\/\^%]+/, 'operator']
            ],
            string_double: [
                [/[^\\"]+/, 'string'],
                [/\\./, 'string.escape.invalid'],
                [/"/, 'string', '@pop']
            ],
            string_single: [
                [/[^\\']+/, 'string'],
                [/\\./, 'string.escape.invalid'],
                [/'/, 'string', '@pop']
            ]
        }
    });

    const S = monaco.languages.CompletionItemKind;
    const SNIPPET = monaco.languages.CompletionItemInsertTextRule.InsertAsSnippet;
    const N = INDENT;

    const keywordFunctionSuggestions = [
        {
            label: 'local function ... end',
            kind: S.Snippet,
            insertText: `local function \${1:name}(\${2:})\n${N}\${3:-- body}\nend`,
            insertTextRules: SNIPPET,
            detail: 'local function name() ... end',
            documentation: 'Declares a local function.',
            sortText: '0_local_function'
        },
        {
            label: 'function ... end',
            kind: S.Snippet,
            insertText: `function \${1:name}(\${2:})\n${N}\${3:-- body}\nend`,
            insertTextRules: SNIPPET,
            detail: 'function name() ... end',
            documentation: 'Declares a global function.',
            sortText: '0_function'
        },
        {
            label: 'function ... : ... end',
            kind: S.Snippet,
            insertText: `function \${1:object}:\${2:method}(\${3:})\n${N}\${4:-- body}\nend`,
            insertTextRules: SNIPPET,
            detail: 'function obj:method() ... end',
            documentation: 'Declares a method.',
            sortText: '0_function_method'
        },
        {
            label: 'function ... . ... end',
            kind: S.Snippet,
            insertText: `function \${1:module}.\${2:name}(\${3:})\n${N}\${4:-- body}\nend`,
            insertTextRules: SNIPPET,
            detail: 'function module.name() ... end',
            documentation: 'Declares a module function.',
            sortText: '0_function_dot'
        },
        {
            label: 'function ... (callback)',
            kind: S.Snippet,
            insertText: `function(\${1:})\n${N}\${2:-- body}\nend`,
            insertTextRules: SNIPPET,
            detail: 'Anonymous function',
            documentation: 'Anonymous inline function.',
            sortText: '0_function_anon'
        }
    ];

    const localSuggestions = [
        {
            label: 'local',
            kind: S.Keyword,
            insertText: 'local ',
            detail: 'local keyword',
            documentation: 'Declares a local variable.',
            sortText: '0_local_kw'
        },
        {
            label: 'local var = value',
            kind: S.Snippet,
            insertText: 'local ${1:name} = ${2:value}',
            insertTextRules: SNIPPET,
            detail: 'local name = value',
            documentation: 'Declares a local variable with a value.',
            sortText: '0_local_var'
        },
        {
            label: 'local var',
            kind: S.Snippet,
            insertText: 'local ${1:name}',
            insertTextRules: SNIPPET,
            detail: 'local name',
            documentation: 'Declares a local variable.',
            sortText: '0_local_var_only'
        },
        {
            label: 'local a, b = 1, 2',
            kind: S.Snippet,
            insertText: 'local ${1:a}, ${2:b} = ${3:1}, ${4:2}',
            insertTextRules: SNIPPET,
            detail: 'local a, b = 1, 2',
            documentation: 'Multiple local assignment.',
            sortText: '0_local_multi'
        },
        {
            label: 'local tbl = {}',
            kind: S.Snippet,
            insertText: `local \${1:tbl} = {\n${N}\${2}\n}`,
            insertTextRules: SNIPPET,
            detail: 'local tbl = {}',
            documentation: 'Local table declaration.',
            sortText: '0_local_table'
        },
        {
            label: 'local function ... end',
            kind: S.Snippet,
            insertText: `local function \${1:name}(\${2:})\n${N}\${3:-- body}\nend`,
            insertTextRules: SNIPPET,
            detail: 'local function name() ... end',
            documentation: 'Declares a local function.',
            sortText: '0_local_function'
        },
        {
            label: 'local var = require(...)',
            kind: S.Snippet,
            insertText: 'local ${1:module} = require(${2:script.Parent.ModuleScript})',
            insertTextRules: SNIPPET,
            detail: 'local module = require(...)',
            documentation: 'Requires a ModuleScript.',
            sortText: '0_local_require'
        }
    ];

    const thenBlockSuggestion = {
        label: 'then ... end  (close if)',
        kind: S.Snippet,
        insertText: `then\n${N}\${1:-- body}\nend`,
        insertTextRules: SNIPPET,
        detail: 'then ... end',
        documentation: 'Completes the current if statement.',
        sortText: '0_then_end'
    };

    const thenElseBlockSuggestion = {
        label: 'then ... else ... end',
        kind: S.Snippet,
        insertText: `then\n${N}\${1:-- body}\nelse\n${N}\${2:-- else body}\nend`,
        insertTextRules: SNIPPET,
        detail: 'then ... else ... end',
        documentation: 'Adds an else branch and closes the if.',
        sortText: '0_then_else'
    };

    const thenElseifBlockSuggestion = {
        label: 'then ... elseif ... then ... end',
        kind: S.Snippet,
        insertText: `then\n${N}\${1:-- body}\nelseif \${2:condition2} then\n${N}\${3:-- body2}\nend`,
        insertTextRules: SNIPPET,
        detail: 'then ... elseif ... then ... end',
        documentation: 'Adds an elseif branch and closes the if.',
        sortText: '0_then_elseif'
    };

    const elseBlockSuggestion = {
        label: 'else ... end  (close if)',
        kind: S.Snippet,
        insertText: `else\n${N}\${1:-- body}\nend`,
        insertTextRules: SNIPPET,
        detail: 'else ... end',
        documentation: 'Closes the if statement with an else branch.',
        sortText: '0_else_end'
    };

    const elseifBlockSuggestion = {
        label: 'elseif ... then ... end',
        kind: S.Snippet,
        insertText: `elseif \${1:condition} then\n${N}\${2:-- body}\nend`,
        insertTextRules: SNIPPET,
        detail: 'elseif ... then ... end',
        documentation: 'Adds an elseif branch and closes the if.',
        sortText: '0_elseif_end'
    };

    const doBlockSuggestion = {
        label: 'do ... end  (close loop)',
        kind: S.Snippet,
        insertText: `do\n${N}\${1:-- body}\nend`,
        insertTextRules: SNIPPET,
        detail: 'do ... end',
        documentation: 'Completes the loop body.',
        sortText: '0_do_end'
    };

    const booleanSuggestions = [
        {
            label: 'true',
            kind: S.Keyword,
            insertText: 'true',
            detail: 'boolean true',
            documentation: 'Lua boolean true.',
            sortText: '0_true'
        },
        {
            label: 'false',
            kind: S.Keyword,
            insertText: 'false',
            detail: 'boolean false',
            documentation: 'Lua boolean false.',
            sortText: '0_false'
        },
        {
            label: 'nil',
            kind: S.Keyword,
            insertText: 'nil',
            detail: 'nil value',
            documentation: 'Lua nil value.',
            sortText: '0_nil'
        }
    ];

    const baseSuggestions = [
        { label: 'game', kind: S.Variable, insertText: 'game', detail: 'Roblox DataModel' },
        { label: 'workspace', kind: S.Variable, insertText: 'workspace', detail: 'Workspace service' },
        { label: 'script', kind: S.Variable, insertText: 'script', detail: 'Current script' },
        { label: 'true', kind: S.Keyword, insertText: 'true', detail: 'Boolean true' },
        { label: 'false', kind: S.Keyword, insertText: 'false', detail: 'Boolean false' },
        { label: 'nil', kind: S.Keyword, insertText: 'nil', detail: 'nil value' },
        { label: 'Instance.new', kind: S.Function, insertText: 'Instance.new("${1:Part}")', insertTextRules: SNIPPET, detail: 'Creates a new Instance' },
        { label: 'task.wait', kind: S.Function, insertText: 'task.wait(${1:1})', insertTextRules: SNIPPET, detail: 'Yields thread' },
        { label: 'task.spawn', kind: S.Function, insertText: `task.spawn(function()\n${N}\${1:-- code}\nend)`, insertTextRules: SNIPPET, detail: 'Runs on new thread' },
        { label: 'task.delay', kind: S.Function, insertText: `task.delay(\${1:1}, function()\n${N}\${2:-- code}\nend)`, insertTextRules: SNIPPET, detail: 'Delayed call' },
        { label: 'print', kind: S.Function, insertText: 'print(${1:value})', insertTextRules: SNIPPET, detail: 'Logs output' },
        { label: 'warn', kind: S.Function, insertText: 'warn(${1:value})', insertTextRules: SNIPPET, detail: 'Logs warning' },
        { label: 'pcall', kind: S.Function, insertText: `pcall(function()\n${N}\${1:-- code}\nend)`, insertTextRules: SNIPPET, detail: 'Protected call' },
        { label: 'if ... then ... end', kind: S.Snippet, insertText: `if \${1:condition} then\n${N}\${2:-- body}\nend`, insertTextRules: SNIPPET, detail: 'if statement' },
        { label: 'if ... then ... else ... end', kind: S.Snippet, insertText: `if \${1:condition} then\n${N}\${2:-- body}\nelse\n${N}\${3:-- else body}\nend`, insertTextRules: SNIPPET, detail: 'if-else statement' },
        { label: 'if ... elseif ... else ... end', kind: S.Snippet, insertText: `if \${1:condition} then\n${N}\${2:-- body}\nelseif \${3:condition2} then\n${N}\${4:-- body2}\nelse\n${N}\${5:-- else body}\nend`, insertTextRules: SNIPPET, detail: 'if-elseif-else statement' },
        { label: 'for i = 1, n do ... end', kind: S.Snippet, insertText: `for \${1:i} = \${2:1}, \${3:10} do\n${N}\${4:-- body}\nend`, insertTextRules: SNIPPET, detail: 'numeric for loop' },
        { label: 'for _, v in pairs(table) do ... end', kind: S.Snippet, insertText: `for \${1:_, \${2:v}} in pairs(\${3:table}) do\n${N}\${4:-- body}\nend`, insertTextRules: SNIPPET, detail: 'pairs iteration' },
        { label: 'for i, v in ipairs(table) do ... end', kind: S.Snippet, insertText: `for \${1:i}, \${2:v} in ipairs(\${3:table}) do\n${N}\${4:-- body}\nend`, insertTextRules: SNIPPET, detail: 'ipairs iteration (arrays)' },
        { label: 'for k, v in next, table do ... end', kind: S.Snippet, insertText: `for \${1:k}, \${2:v} in next, \${3:table} do\n${N}\${4:-- body}\nend`, insertTextRules: SNIPPET, detail: 'next iteration' },
        { label: 'while ... do ... end', kind: S.Snippet, insertText: `while \${1:condition} do\n${N}\${2:-- body}\nend`, insertTextRules: SNIPPET, detail: 'while loop' },
        { label: 'repeat ... until', kind: S.Snippet, insertText: `repeat\n${N}\${1:-- body}\nuntil \${2:condition}`, insertTextRules: SNIPPET, detail: 'repeat loop' },
        { label: 'do ... end', kind: S.Snippet, insertText: `do\n${N}\${1:-- body}\nend`, insertTextRules: SNIPPET, detail: 'do block' },
        { label: 'pairs()', kind: S.Function, insertText: 'pairs(${1:table})', insertTextRules: SNIPPET, detail: 'pairs(t) → iterator' },
        { label: 'ipairs()', kind: S.Function, insertText: 'ipairs(${1:table})', insertTextRules: SNIPPET, detail: 'ipairs(t) → array iterator' },
        { label: 'next()', kind: S.Function, insertText: 'next(${1:table}, ${2:nil})', insertTextRules: SNIPPET, detail: 'next(t, key) → key, value' }
    ];

    const gameMethods = [
        { label: 'GetService', kind: S.Method, insertText: 'GetService("${1:Players}")', insertTextRules: SNIPPET, detail: 'game:GetService(name)', documentation: 'Returns the service with the given class name.' },
        { label: 'FindFirstChild', kind: S.Method, insertText: 'FindFirstChild("${1:Name}")', insertTextRules: SNIPPET, detail: 'game:FindFirstChild(name, recursive)' },
        { label: 'WaitForChild', kind: S.Method, insertText: 'WaitForChild("${1:Name}")', insertTextRules: SNIPPET, detail: 'game:WaitForChild(name, timeout)' },
        { label: 'GetChildren', kind: S.Method, insertText: 'GetChildren()', detail: 'game:GetChildren()' },
        { label: 'GetDescendants', kind: S.Method, insertText: 'GetDescendants()', detail: 'game:GetDescendants()' },
        { label: 'IsLoaded', kind: S.Method, insertText: 'IsLoaded()', detail: 'game:IsLoaded()' },
        { label: 'HttpGet', kind: S.Method, insertText: 'HttpGet("${1:url}")', insertTextRules: SNIPPET, detail: 'game:HttpGet(url)' },
        { label: 'HttpPost', kind: S.Method, insertText: 'HttpPost("${1:url}", ${2:data})', insertTextRules: SNIPPET, detail: 'game:HttpPost(url, data)' }
    ];

    const instanceMethods = [
        { label: 'FindFirstChild', kind: S.Method, insertText: 'FindFirstChild("${1:Name}")', insertTextRules: SNIPPET, detail: ':FindFirstChild(name)' },
        { label: 'WaitForChild', kind: S.Method, insertText: 'WaitForChild("${1:Name}")', insertTextRules: SNIPPET, detail: ':WaitForChild(name)' },
        { label: 'FindFirstChildOfClass', kind: S.Method, insertText: 'FindFirstChildOfClass("${1:Part}")', insertTextRules: SNIPPET, detail: ':FindFirstChildOfClass(className)' },
        { label: 'FindFirstChildWhichIsA', kind: S.Method, insertText: 'FindFirstChildWhichIsA("${1:BasePart}")', insertTextRules: SNIPPET, detail: ':FindFirstChildWhichIsA(className)' },
        { label: 'FindFirstAncestor', kind: S.Method, insertText: 'FindFirstAncestor("${1:Name}")', insertTextRules: SNIPPET, detail: ':FindFirstAncestor(name)' },
        { label: 'GetChildren', kind: S.Method, insertText: 'GetChildren()', detail: ':GetChildren()' },
        { label: 'GetDescendants', kind: S.Method, insertText: 'GetDescendants()', detail: ':GetDescendants()' },
        { label: 'GetAttribute', kind: S.Method, insertText: 'GetAttribute("${1:Name}")', insertTextRules: SNIPPET, detail: ':GetAttribute(name)' },
        { label: 'SetAttribute', kind: S.Method, insertText: 'SetAttribute("${1:Name}", ${2:value})', insertTextRules: SNIPPET, detail: ':SetAttribute(name, value)' },
        { label: 'GetPropertyChangedSignal', kind: S.Method, insertText: 'GetPropertyChangedSignal("${1:Name}")', insertTextRules: SNIPPET, detail: ':GetPropertyChangedSignal(property)' },
        { label: 'IsA', kind: S.Method, insertText: 'IsA("${1:BasePart}")', insertTextRules: SNIPPET, detail: ':IsA(className)' },
        { label: 'Clone', kind: S.Method, insertText: 'Clone()', detail: ':Clone()' },
        { label: 'Destroy', kind: S.Method, insertText: 'Destroy()', detail: ':Destroy()' },
        { label: 'GetPivot', kind: S.Method, insertText: 'GetPivot()', detail: ':GetPivot()' },
        { label: 'PivotTo', kind: S.Method, insertText: 'PivotTo(${1:CFrame.new()})', insertTextRules: SNIPPET, detail: ':PivotTo(cframe)' }
    ];

    const executorEnvFunctions = [
        { label: 'getgenv', kind: S.Function, insertText: 'getgenv()', detail: 'getgenv()', documentation: 'Returns the executor global environment.' },
        { label: 'getrenv', kind: S.Function, insertText: 'getrenv()', detail: 'getrenv()', documentation: "Returns the Roblox global environment (game's env)." },
        { label: 'getreg', kind: S.Function, insertText: 'getreg()', detail: 'getreg()', documentation: 'Returns the Lua registry table.' },
        { label: 'getgc', kind: S.Function, insertText: 'getgc(${1:false})', insertTextRules: SNIPPET, detail: 'getgc(includetables?)', documentation: 'Returns a copy of the Lua GC list.' },
        { label: 'getinstances', kind: S.Function, insertText: 'getinstances()', detail: 'getinstances()', documentation: 'Returns all instances in the game.' },
        { label: 'getnilinstances', kind: S.Function, insertText: 'getnilinstances()', detail: 'getnilinstances()', documentation: 'Returns all instances parented to nil.' },
        { label: 'getscripts', kind: S.Function, insertText: 'getscripts()', detail: 'getscripts()', documentation: 'Returns a list of all scripts in the game.' },
        { label: 'getloadedmodules', kind: S.Function, insertText: 'getloadedmodules()', detail: 'getloadedmodules()', documentation: 'Returns all loaded ModuleScripts.' },
        { label: 'getrunningscripts', kind: S.Function, insertText: 'getrunningscripts()', detail: 'getrunningscripts()', documentation: 'Returns currently running scripts.' },
        { label: 'getsenv', kind: S.Function, insertText: 'getsenv(${1:script})', insertTextRules: SNIPPET, detail: 'getsenv(script)', documentation: 'Returns the environment of a Script.' },
        { label: 'getmenv', kind: S.Function, insertText: 'getmenv(${1:module})', insertTextRules: SNIPPET, detail: 'getmenv(module)', documentation: 'Returns the environment of a ModuleScript.' },
        { label: 'gettenv', kind: S.Function, insertText: 'gettenv(${1:thread})', insertTextRules: SNIPPET, detail: 'gettenv(thread)', documentation: 'Returns the environment of a thread.' },
        { label: 'getfenv', kind: S.Function, insertText: 'getfenv(${1:target})', insertTextRules: SNIPPET, detail: 'getfenv(target?)', documentation: 'Returns the environment of a function or level.' },
        { label: 'setfenv', kind: S.Function, insertText: 'setfenv(${1:function}, ${2:env})', insertTextRules: SNIPPET, detail: 'setfenv(f, env)', documentation: 'Sets the environment of function f.' },
        { label: 'checkcaller', kind: S.Function, insertText: 'checkcaller()', detail: 'checkcaller()', documentation: 'Returns true if the current thread was made by the executor.' },
        { label: 'getcallingscript', kind: S.Function, insertText: 'getcallingscript()', detail: 'getcallingscript()', documentation: 'Returns the script that is currently executing.' },
        { label: 'getthreadidentity', kind: S.Function, insertText: 'getthreadidentity()', detail: 'getthreadidentity()', documentation: "Returns the current thread's identity." },
        { label: 'setthreadidentity', kind: S.Function, insertText: 'setthreadidentity(${1:8})', insertTextRules: SNIPPET, detail: 'setthreadidentity(identity)', documentation: "Sets the current thread's identity." },
        { label: 'getnamecallmethod', kind: S.Function, insertText: 'getnamecallmethod()', detail: 'getnamecallmethod()', documentation: 'Returns the namecall method inside a __namecall hook.' },
        { label: 'setnamecallmethod', kind: S.Function, insertText: 'setnamecallmethod(${1:"FireServer"})', insertTextRules: SNIPPET, detail: 'setnamecallmethod(method)', documentation: 'Sets the namecall method.' },
        { label: 'identifyexecutor', kind: S.Function, insertText: 'identifyexecutor()', detail: 'identifyexecutor()', documentation: 'Returns the executor name and version.' },
        { label: 'getexecutorname', kind: S.Function, insertText: 'getexecutorname()', detail: 'getexecutorname()', documentation: 'Alias for identifyexecutor.' },
        { label: 'setclipboard', kind: S.Function, insertText: 'setclipboard("${1:text}")', insertTextRules: SNIPPET, detail: 'setclipboard(text)', documentation: 'Copies text to the clipboard.' },
        { label: 'getclipboard', kind: S.Function, insertText: 'getclipboard()', detail: 'getclipboard()', documentation: 'Returns clipboard content.' },
        { label: 'queue_on_teleport', kind: S.Function, insertText: 'queue_on_teleport("${1:code}")', insertTextRules: SNIPPET, detail: 'queue_on_teleport(code)', documentation: 'Queues a script to run after teleport.' },
        { label: 'request', kind: S.Function, insertText: `request({\n${N}Url = "\${1:url}",\n${N}Method = "\${2:GET}"\n})`, insertTextRules: SNIPPET, detail: 'request(options)', documentation: 'Sends an HTTP request.' },
        { label: 'httpget', kind: S.Function, insertText: 'httpget("${1:url}")', insertTextRules: SNIPPET, detail: 'httpget(url)', documentation: 'Sends an HTTP GET request.' },
        { label: 'messagebox', kind: S.Function, insertText: 'messagebox("${1:text}", "${2:caption}", ${3:0})', insertTextRules: SNIPPET, detail: 'messagebox(text, caption, flags)', documentation: 'Creates a Windows message box.' },
        { label: 'getfflag', kind: S.Function, insertText: 'getfflag("${1:flagName}")', insertTextRules: SNIPPET, detail: 'getfflag(flag)', documentation: 'Returns the value of a fast flag.' },
        { label: 'setfflag', kind: S.Function, insertText: 'setfflag("${1:flagName}", "${2:value}")', insertTextRules: SNIPPET, detail: 'setfflag(flag, value)', documentation: 'Sets a fast flag value.' },
        { label: 'gethwid', kind: S.Function, insertText: 'gethwid()', detail: 'gethwid()', documentation: 'Returns the hardware ID.' },
        { label: 'gethui', kind: S.Function, insertText: 'gethui()', detail: 'gethui()', documentation: 'Returns a hidden UI container (CoreGui).' },
        { label: 'getcustomasset', kind: S.Function, insertText: 'getcustomasset("${1:path}")', insertTextRules: SNIPPET, detail: 'getcustomasset(path)', documentation: 'Returns an rbxasset:// URL for a local file.' },
        { label: 'getspecialinfo', kind: S.Function, insertText: 'getspecialinfo()', detail: 'getspecialinfo()', documentation: 'Returns a table with special user info (HWID, etc).' }
    ];

    const executorGlobalSuggestions = [
        { label: '_G', kind: S.Variable, insertText: '_G', detail: '_G', documentation: "Executor's global table. Shared across all executor scripts.", sortText: '0_g' },
        { label: 'key = value', kind: S.Snippet, insertText: '${1:key} = ${2:value}', insertTextRules: SNIPPET, detail: '_G.key = value', documentation: 'Sets a global value in _G.', sortText: '0_g_set' },
        { label: 'key', kind: S.Snippet, insertText: '${1:key}', insertTextRules: SNIPPET, detail: '_G.key', documentation: 'Reads a global value from _G.', sortText: '0_g_get' },
        { label: 'key (bool)', kind: S.Snippet, insertText: '${1:key} = ${2|true,false|}', insertTextRules: SNIPPET, detail: '_G.key = true/false', documentation: 'Sets a boolean global value in _G.', sortText: '0_g_bool' },
        { label: 'key (string)', kind: S.Snippet, insertText: '${1:key} = "${2:value}"', insertTextRules: SNIPPET, detail: '_G.key = "value"', documentation: 'Sets a string global value in _G.', sortText: '0_g_str' },
        { label: 'rawget(_G, key)', kind: S.Function, insertText: 'rawget(_G, "${1:key}")', insertTextRules: SNIPPET, detail: 'rawget(_G, key)', documentation: 'Reads raw value from _G without metamethods.' },
        { label: 'rawset(_G, key, val)', kind: S.Function, insertText: 'rawset(_G, "${1:key}", ${2:value})', insertTextRules: SNIPPET, detail: 'rawset(_G, key, val)', documentation: 'Sets raw value in _G without metamethods.' },
        { label: 'for k, v in pairs(_G) do ... end', kind: S.Snippet, insertText: `for \${1:k}, \${2:v} in pairs(_G) do\n${N}\${3:-- body}\nend`, insertTextRules: SNIPPET, detail: 'Iterate _G entries', documentation: 'Iterates all entries of _G.' },
        { label: 'getgenv()', kind: S.Function, insertText: 'getgenv()', detail: 'getgenv()', documentation: 'Returns the executor global env (preferred over _G).', sortText: '0_g_getgenv' }
    ];

    const executorMetatableFunctions = [
        { label: 'getrawmetatable', kind: S.Function, insertText: 'getrawmetatable(${1:obj})', insertTextRules: SNIPPET, detail: 'getrawmetatable(obj)', documentation: 'Returns the raw metatable of an object.' },
        { label: 'setrawmetatable', kind: S.Function, insertText: 'setrawmetatable(${1:obj}, ${2:mt})', insertTextRules: SNIPPET, detail: 'setrawmetatable(obj, mt)', documentation: 'Sets the metatable of an object.' },
        { label: 'setreadonly', kind: S.Function, insertText: 'setreadonly(${1:table}, ${2:true})', insertTextRules: SNIPPET, detail: 'setreadonly(table, bool)', documentation: 'Toggles the readonly flag on a table.' },
        { label: 'isreadonly', kind: S.Function, insertText: 'isreadonly(${1:table})', insertTextRules: SNIPPET, detail: 'isreadonly(table)', documentation: 'Returns whether a table is readonly.' },
        { label: 'hookfunction', kind: S.Function, insertText: `hookfunction(\${1:old}, function(...)\n${N}\${2:-- code}\n${N}return \${3:old}(...)\nend)`, insertTextRules: SNIPPET, detail: 'hookfunction(old, hook)', documentation: 'Hooks a function, returns the original.' },
        { label: 'hookmetamethod', kind: S.Function, insertText: `hookmetamethod(game, "\${1:__namecall}", function(self, ...)\n${N}\${2:-- code}\n${N}return \${3:old}(self, ...)\nend)`, insertTextRules: SNIPPET, detail: 'hookmetamethod(obj, method, hook)', documentation: 'Hooks a metamethod.' },
        { label: 'newcclosure', kind: S.Function, insertText: `newcclosure(function(...)\n${N}\${1:-- code}\nend)`, insertTextRules: SNIPPET, detail: 'newcclosure(fn)', documentation: 'Creates a new C closure.' },
        { label: 'iscclosure', kind: S.Function, insertText: 'iscclosure(${1:fn})', insertTextRules: SNIPPET, detail: 'iscclosure(fn)', documentation: 'Returns true if fn is a C closure.' },
        { label: 'islclosure', kind: S.Function, insertText: 'islclosure(${1:fn})', insertTextRules: SNIPPET, detail: 'islclosure(fn)', documentation: 'Returns true if fn is a Lua closure.' },
        { label: 'clonefunction', kind: S.Function, insertText: 'clonefunction(${1:fn})', insertTextRules: SNIPPET, detail: 'clonefunction(fn)', documentation: 'Clones a function.' },
        { label: 'restorefunction', kind: S.Function, insertText: 'restorefunction(${1:fn})', insertTextRules: SNIPPET, detail: 'restorefunction(fn)', documentation: 'Restores a hooked function.' }
    ];

    const executorScriptFunctions = [
        { label: 'getscripthash', kind: S.Function, insertText: 'getscripthash(${1:script})', insertTextRules: SNIPPET, detail: 'getscripthash(script)', documentation: "Returns the hash of a script's bytecode." },
        { label: 'getscriptbytecode', kind: S.Function, insertText: 'getscriptbytecode(${1:script})', insertTextRules: SNIPPET, detail: 'getscriptbytecode(script)', documentation: 'Returns raw bytecode of a script.' },
        { label: 'getscriptclosure', kind: S.Function, insertText: 'getscriptclosure(${1:script})', insertTextRules: SNIPPET, detail: 'getscriptclosure(script)', documentation: 'Generates a closure from a script.' },
        { label: 'getscriptfromthread', kind: S.Function, insertText: 'getscriptfromthread(${1:thread})', insertTextRules: SNIPPET, detail: 'getscriptfromthread(thread)', documentation: 'Returns the script associated with a thread.' },
        { label: 'decompile', kind: S.Function, insertText: 'decompile(${1:script})', insertTextRules: SNIPPET, detail: 'decompile(script)', documentation: 'Decompiles a script and returns source.' },
        { label: 'saveinstance', kind: S.Function, insertText: 'saveinstance(${1:game}, "${2:file}", {})', insertTextRules: SNIPPET, detail: 'saveinstance(obj, path, options)', documentation: 'Saves the game or an instance to a file.' },
        {
            label: 'loadstring(value)()',
            kind: S.Function,
            insertText: 'loadstring(${1:value})()',
            insertTextRules: SNIPPET,
            detail: 'loadstring(value)()',
            documentation: 'Compiles and runs a Lua string value.',
            sortText: '0_loadstring_value'
        },
        {
            label: 'loadstring(game:HttpGet("url"))()',
            kind: S.Function,
            insertText: 'loadstring(game:HttpGet("${1:url}"))()',
            insertTextRules: SNIPPET,
            detail: 'loadstring(game:HttpGet(url))()',
            documentation: 'Fetches and runs a remote Lua script.',
            sortText: '1_loadstring_http'
        }
    ];

    const executorFileFunctions = [
        { label: 'readfile', kind: S.Function, insertText: 'readfile("${1:path}")', insertTextRules: SNIPPET, detail: 'readfile(path)', documentation: 'Reads a file from the workspace folder.' },
        { label: 'writefile', kind: S.Function, insertText: 'writefile("${1:path}", "${2:data}")', insertTextRules: SNIPPET, detail: 'writefile(path, data)', documentation: 'Writes data to a file.' },
        { label: 'appendfile', kind: S.Function, insertText: 'appendfile("${1:path}", "${2:data}")', insertTextRules: SNIPPET, detail: 'appendfile(path, data)', documentation: 'Appends data to a file.' },
        { label: 'isfile', kind: S.Function, insertText: 'isfile("${1:path}")', insertTextRules: SNIPPET, detail: 'isfile(path)', documentation: 'Returns true if path is a file.' },
        { label: 'isfolder', kind: S.Function, insertText: 'isfolder("${1:path}")', insertTextRules: SNIPPET, detail: 'isfolder(path)', documentation: 'Returns true if path is a folder.' },
        { label: 'makefolder', kind: S.Function, insertText: 'makefolder("${1:path}")', insertTextRules: SNIPPET, detail: 'makefolder(path)', documentation: 'Creates a new folder.' },
        { label: 'delfile', kind: S.Function, insertText: 'delfile("${1:path}")', insertTextRules: SNIPPET, detail: 'delfile(path)', documentation: 'Deletes a file.' },
        { label: 'delfolder', kind: S.Function, insertText: 'delfolder("${1:path}")', insertTextRules: SNIPPET, detail: 'delfolder(path)', documentation: 'Deletes a folder.' },
        { label: 'listfiles', kind: S.Function, insertText: 'listfiles("${1:path}")', insertTextRules: SNIPPET, detail: 'listfiles(path)', documentation: 'Lists files and folders at path.' },
        { label: 'loadfile', kind: S.Function, insertText: 'loadfile("${1:path}")()', insertTextRules: SNIPPET, detail: 'loadfile(path)', documentation: 'Loads and runs a file.' }
    ];

    const executorInputFunctions = [
        { label: 'isrbxactive', kind: S.Function, insertText: 'isrbxactive()', detail: 'isrbxactive()', documentation: 'Returns true if the Roblox window is focused.' },
        { label: 'keypress', kind: S.Function, insertText: 'keypress(${1:keycode})', insertTextRules: SNIPPET, detail: 'keypress(keycode)', documentation: 'Simulates a key press.' },
        { label: 'keyrelease', kind: S.Function, insertText: 'keyrelease(${1:keycode})', insertTextRules: SNIPPET, detail: 'keyrelease(keycode)', documentation: 'Releases a key.' },
        { label: 'mouse1click', kind: S.Function, insertText: 'mouse1click()', detail: 'mouse1click()', documentation: 'Simulates a left mouse click.' },
        { label: 'mouse1press', kind: S.Function, insertText: 'mouse1press()', detail: 'mouse1press()', documentation: 'Presses the left mouse button.' },
        { label: 'mouse1release', kind: S.Function, insertText: 'mouse1release()', detail: 'mouse1release()', documentation: 'Releases the left mouse button.' },
        { label: 'mouse2click', kind: S.Function, insertText: 'mouse2click()', detail: 'mouse2click()', documentation: 'Simulates a right mouse click.' },
        { label: 'mouse2press', kind: S.Function, insertText: 'mouse2press()', detail: 'mouse2press()', documentation: 'Presses the right mouse button.' },
        { label: 'mouse2release', kind: S.Function, insertText: 'mouse2release()', detail: 'mouse2release()', documentation: 'Releases the right mouse button.' },
        { label: 'mousescroll', kind: S.Function, insertText: 'mousescroll(${1:px})', insertTextRules: SNIPPET, detail: 'mousescroll(px)', documentation: 'Scrolls the mouse wheel.' },
        { label: 'mousemoverel', kind: S.Function, insertText: 'mousemoverel(${1:x}, ${2:y})', insertTextRules: SNIPPET, detail: 'mousemoverel(x, y)', documentation: 'Moves the mouse cursor relatively.' }
    ];

    const executorSignalFunctions = [
        { label: 'getconnections', kind: S.Function, insertText: 'getconnections(${1:signal})', insertTextRules: SNIPPET, detail: 'getconnections(signal)', documentation: 'Returns connections to a signal.' },
        { label: 'firesignal', kind: S.Function, insertText: 'firesignal(${1:signal})', insertTextRules: SNIPPET, detail: 'firesignal(signal, ...)', documentation: 'Fires a signal with arguments.' },
        { label: 'fireclickdetector', kind: S.Function, insertText: 'fireclickdetector(${1:clickdetector})', insertTextRules: SNIPPET, detail: 'fireclickdetector(obj)', documentation: 'Fires a ClickDetector.' },
        { label: 'firetouchinterest', kind: S.Function, insertText: 'firetouchinterest(${1:part}, ${2:touchPart}, ${3:0})', insertTextRules: SNIPPET, detail: 'firetouchinterest(part, touchPart, toggle)', documentation: 'Fires a Touched event.' },
        { label: 'getproximityprompt', kind: S.Function, insertText: 'getproximityprompt(${1:instance})', insertTextRules: SNIPPET, detail: 'getproximityprompt(instance)', documentation: 'Returns a ProximityPrompt.' },
        { label: 'getcallbackvalue', kind: S.Function, insertText: 'getcallbackvalue(${1:instance}, "${2:Name}")', insertTextRules: SNIPPET, detail: 'getcallbackvalue(obj, property)', documentation: 'Returns a callback value (e.g. OnClientInvoke).' }
    ];

    const executorDebugFunctions = [
        { label: 'debug.getupvalues', kind: S.Function, insertText: 'debug.getupvalues(${1:func})', insertTextRules: SNIPPET, detail: 'debug.getupvalues(f)' },
        { label: 'debug.setupvalue', kind: S.Function, insertText: 'debug.setupvalue(${1:func}, ${2:index}, ${3:value})', insertTextRules: SNIPPET, detail: 'debug.setupvalue(f, idx, val)' },
        { label: 'debug.getconstants', kind: S.Function, insertText: 'debug.getconstants(${1:func})', insertTextRules: SNIPPET, detail: 'debug.getconstants(f)' },
        { label: 'debug.setconstant', kind: S.Function, insertText: 'debug.setconstant(${1:func}, ${2:index}, ${3:value})', insertTextRules: SNIPPET, detail: 'debug.setconstant(f, idx, val)' },
        { label: 'debug.getprotos', kind: S.Function, insertText: 'debug.getprotos(${1:func})', insertTextRules: SNIPPET, detail: 'debug.getprotos(f)' },
        { label: 'debug.getstack', kind: S.Function, insertText: 'debug.getstack(${1:level})', insertTextRules: SNIPPET, detail: 'debug.getstack(level)' },
        { label: 'debug.getlocal', kind: S.Function, insertText: 'debug.getlocal(${1:level}, ${2:index})', insertTextRules: SNIPPET, detail: 'debug.getlocal(level, idx)' },
        { label: 'debug.setlocal', kind: S.Function, insertText: 'debug.setlocal(${1:level}, ${2:index}, ${3:value})', insertTextRules: SNIPPET, detail: 'debug.setlocal(level, idx, val)' }
    ];

    const allExecutorSuggestions = [
        ...executorEnvFunctions,
        ...executorGlobalSuggestions,
        ...executorMetatableFunctions,
        ...executorScriptFunctions,
        ...executorFileFunctions,
        ...executorInputFunctions,
        ...executorSignalFunctions,
        ...executorDebugFunctions
    ];

    monaco.languages.registerCompletionItemProvider('lua', {
        triggerCharacters: [':', '.', ' ', '=', '(', ','],
        provideCompletionItems: (model, position) => {
            const lineUntil = model.getValueInRange({
                startLineNumber: position.lineNumber,
                startColumn: 1,
                endLineNumber: position.lineNumber,
                endColumn: position.column
            });

            const word = model.getWordUntilPosition(position);
            const range = {
                startLineNumber: position.lineNumber,
                endLineNumber: position.lineNumber,
                startColumn: word.startColumn,
                endColumn: word.endColumn
            };

            const withRange = (s) => ({ ...s, range });

            const fullCode = model.getValue();
            const userFunctions = extractUserFunctions(fullCode);
            const userCallSuggestions = userFunctions.map(fn =>
                buildFunctionCallSuggestion(fn, S, SNIPPET, withRange)
            );

            if (/\bif\s+[^\n]*\bthen\b[^\n]*$/i.test(lineUntil) && !/\bend\b/i.test(lineUntil) && !/\bthen\s*\w*$/i.test(lineUntil)) {
                return {
                    suggestions: [
                        thenBlockSuggestion,
                        thenElseBlockSuggestion,
                        thenElseifBlockSuggestion
                    ].map(withRange)
                };
            }

            if (/\bthen\s*\w*$/i.test(lineUntil) && !/\bend\b/i.test(lineUntil)) {
                return {
                    suggestions: [
                        thenBlockSuggestion,
                        thenElseBlockSuggestion,
                        thenElseifBlockSuggestion
                    ].map(withRange)
                };
            }

            if (/\belse\s*\w*$/i.test(lineUntil) && !/\bend\b/i.test(lineUntil)) {
                return {
                    suggestions: [
                        elseBlockSuggestion,
                        elseifBlockSuggestion
                    ].map(withRange)
                };
            }

            if (/\belseif\s+[^\n]*$/i.test(lineUntil) && !/\bthen\b/i.test(lineUntil) && !/\bend\b/i.test(lineUntil)) {
                return {
                    suggestions: [elseifBlockSuggestion].map(withRange)
                };
            }

            if (/\b(for|while)\s+[^\n]*\bdo\s*\w*$/i.test(lineUntil) && !/\bend\b/i.test(lineUntil)) {
                return {
                    suggestions: [doBlockSuggestion].map(withRange)
                };
            }

            if (/\brepeat\s*\w*$/i.test(lineUntil)) {
                return {
                    suggestions: [{
                        label: 'until ...',
                        kind: S.Snippet,
                        insertText: 'until ${1:condition}',
                        insertTextRules: SNIPPET,
                        detail: 'until condition',
                        sortText: '0_until'
                    }].map(withRange)
                };
            }

            if (/\bgame\s*:\s*\w*$/.test(lineUntil)) {
                return { suggestions: gameMethods.map(withRange).concat(userCallSuggestions) };
            }

            if (/(workspace|game\.Workspace|Players|ReplicatedStorage|ServerStorage|ServerScriptService|StarterGui|StarterPlayer|RunService|TweenService|HttpService)\s*:\s*\w*$/.test(lineUntil)) {
                return { suggestions: instanceMethods.map(withRange).concat(userCallSuggestions) };
            }

            if (/\w+\s*:\s*\w*$/.test(lineUntil)) {
                return { suggestions: instanceMethods.map(withRange).concat(userCallSuggestions) };
            }

            if (/\b_G\s*\.\s*\w*$/.test(lineUntil) || /\bgetgenv\(\)\s*\.\s*\w*$/.test(lineUntil)) {
                return { suggestions: executorGlobalSuggestions.filter(s => s.label !== '_G').map(withRange) };
            }

            if (/\b_G\s*$/.test(lineUntil)) {
                return { suggestions: executorGlobalSuggestions.map(withRange) };
            }

            if (/\bl(?:o(?:c(?:a(?:l)?)?)?)?$/.test(lineUntil)) {
                return {
                    suggestions: localSuggestions.map(withRange)
                        .concat(keywordFunctionSuggestions.map(withRange))
                        .concat(booleanSuggestions.map(withRange))
                        .concat(userCallSuggestions)
                };
            }

            if (/=\s*\w*$/.test(lineUntil) || /\(\s*\w*$/.test(lineUntil) || /,\s*\w*$/.test(lineUntil)) {
                return {
                    suggestions: booleanSuggestions.map(withRange)
                        .concat(baseSuggestions.map(withRange))
                        .concat(userCallSuggestions)
                        .concat(allExecutorSuggestions.map(withRange))
                };
            }

            if (/\bfunction\s*$/.test(lineUntil) || /\blocal\s+function\s*$/.test(lineUntil)) {
                return {
                    suggestions: keywordFunctionSuggestions.map(withRange)
                        .concat(userCallSuggestions)
                        .concat(allExecutorSuggestions.map(withRange))
                };
            }

            const isExecutorContext = /\b(get|set|hook|fire|load|save|decompile|identify|check|is)[a-z]*\w*$/i.test(lineUntil) ||
                /\b[A-Z][a-z]+[A-Z]?\w*$/.test(lineUntil);

            if (isExecutorContext) {
                return {
                    suggestions: allExecutorSuggestions.map(withRange)
                        .concat(userCallSuggestions)
                        .concat(baseSuggestions.map(withRange))
                };
            }

            return {
                suggestions: localSuggestions.map(withRange)
                    .concat(keywordFunctionSuggestions.map(withRange))
                    .concat(userCallSuggestions)
                    .concat(allExecutorSuggestions.map(withRange))
                    .concat(booleanSuggestions.map(withRange))
                    .concat(baseSuggestions.map(withRange))
            };
        }
    });
}

async function mountMonaco() {
    try {
        const monaco = await loadMonaco();
        defineThemes(monaco);
        registerLua(monaco);

        const host = document.getElementById('monaco-editor');
        if (!host) throw new Error('#monaco-editor not found');

        const theme = document.body.getAttribute('data-theme') === 'light' ? 'luavault-light' : 'luavault-dark';

        editor = monaco.editor.create(host, {
            value: '',
            language: 'lua',
            theme: theme,
            automaticLayout: true,
            fontSize: 14,
            fontFamily: '"JetBrains Mono", monospace',
            fontLigatures: true,
            minimap: { enabled: false },
            scrollbar: { verticalScrollbarSize: 8, horizontalScrollbarSize: 8, useShadows: false },
            smoothScrolling: true,
            cursorBlinking: 'smooth',
            cursorSmoothCaretAnimation: 'on',
            renderLineHighlight: 'all',
            bracketPairColorization: { enabled: true },
            guides: { bracketPairs: true, indentation: true },
            padding: { top: 16, bottom: 16 },
            scrollBeyondLastLine: false,
            lineNumbersMinChars: 3,
            glyphMargin: false,
            folding: true,
            tabSize: 4,
            insertSpaces: true,
            detectIndentation: false,
            trimAutoWhitespace: true,
            autoIndent: 'full',
            formatOnPaste: false,
            formatOnType: false,
            quickSuggestions: { other: true, comments: false, strings: false },
            suggestOnTriggerCharacters: true,
            wordBasedSuggestions: 'currentDocument',
            suggest: { showWords: true, showMethods: true, showFunctions: true }
        });

        editor.addCommand(
            monaco.KeyCode.Tab,
            () => {
                const suggestController = editor.getContribution('editor.contrib.suggestController');
                if (suggestController) {
                    const widget = suggestController.getWidget();
                    if (widget && widget.isVisible()) {
                        editor.trigger('keyboard', 'acceptSelectedSuggestion', {});
                        return;
                    }
                }

                const selection = editor.getSelection();
                const model = editor.getModel();

                if (selection.isEmpty()) {
                    const lineNumber = selection.startLineNumber;
                    const column = selection.startColumn;
                    const lineContent = model.getLineContent(lineNumber);
                    const before = lineContent.substring(0, column - 1);

                    if (before.trim() === '') {
                        const spacesToAdd = 4 - (before.length % 4);
                        editor.executeEdits('tab', [{
                            range: new monaco.Range(lineNumber, column, lineNumber, column),
                            text: ' '.repeat(spacesToAdd)
                        }]);
                        return;
                    }

                    editor.executeEdits('tab', [{
                        range: new monaco.Range(lineNumber, column, lineNumber, column),
                        text: INDENT
                    }]);
                } else {
                    const startLine = selection.startLineNumber;
                    const endLine = selection.endLineNumber;
                    const edits = [];
                    for (let i = startLine; i <= endLine; i++) {
                        edits.push({
                            range: new monaco.Range(i, 1, i, 1),
                            text: INDENT
                        });
                    }
                    editor.executeEdits('tab-indent', edits);
                    editor.setSelection(new monaco.Selection(
                        selection.startLineNumber,
                        selection.startColumn + INDENT.length,
                        selection.endLineNumber,
                        selection.endColumn + INDENT.length
                    ));
                }
            }
        );

        editor.addCommand(
            monaco.KeyMod.Shift | monaco.KeyCode.Tab,
            () => {
                const selection = editor.getSelection();
                const model = editor.getModel();
                const startLine = selection.startLineNumber;
                const endLine = selection.endLineNumber;
                const edits = [];
                for (let i = startLine; i <= endLine; i++) {
                    const lineContent = model.getLineContent(i);
                    let removeCount = 0;
                    for (let j = 0; j < Math.min(INDENT.length, lineContent.length); j++) {
                        if (lineContent[j] === ' ' || lineContent[j] === '\t') removeCount++;
                        else break;
                    }
                    if (removeCount > 0) {
                        edits.push({
                            range: new monaco.Range(i, 1, i, removeCount + 1),
                            text: ''
                        });
                    }
                }
                if (edits.length) editor.executeEdits('tab-unindent', edits);
            }
        );

        setTimeout(() => {
            if (editor) editor.layout();
        }, 100);
    } catch (err) {
        console.error('[main] Monaco init error:', err);
        showToast('Editor failed to load');
    }
}

function getCode() {
    return editor ? editor.getValue() : '';
}

function setCode(v) {
    if (editor) editor.setValue(v || '');
}

function setOverlayActive(active) {
    const overlay = document.getElementById('codeOverlay');
    if (!overlay) return;
    overlay.classList.toggle('active', active);
}

async function callGeminiAPI(prompt, action, currentCode) {
    const res = await fetch(API_ENDPOINT, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ prompt, action, currentCode })
    });

    const textResponse = await res.text();

    if (!res.ok) {
        throw new Error(textResponse || `API error ${res.status}`);
    }

    return textResponse;
}

function startCooldown(btn, btnLabel) {
    generateCooldown = true;
    btn.disabled = true;
    btn.classList.add('cooldown');

    let remaining = COOLDOWN_SECONDS;
    btnLabel.textContent = `${remaining}s`;

    const timer = setInterval(() => {
        remaining -= 1;
        if (remaining > 0) {
            btnLabel.textContent = `${remaining}s`;
        } else {
            clearInterval(timer);
            generateCooldown = false;
            btn.disabled = false;
            btn.classList.remove('cooldown');
            btnLabel.textContent = btn.dataset.originalText || 'Generate';
        }
    }, 1000);
}

async function generateCode() {
    if (generateCooldown) return;

    const prompt = promptInput.value.trim();
    const action = document.getElementById('selectedActionText').textContent;

    if (!prompt) {
        showToast('Please enter a prompt to generate code.');
        return;
    }

    const currentCode = getCode().trim();
    if (action === 'Modify current script' && !currentCode) {
        showToast('Your script is empty. Please generate a new script or write some code first.');
        return;
    }

    const btn = document.getElementById('generateBtn');
    const btnLabel = btn.querySelector('span') || btn;

    if (!btn.dataset.originalText) {
        btn.dataset.originalText = btnLabel.textContent.trim();
    }

    btn.classList.add('loading');
    btn.disabled = true;
    setOverlayActive(true);

    try {
        const code = await callGeminiAPI(prompt, action, currentCode);

        const cleaned = code
            .replace(/^```(?:lua|luau)?\s*/i, '')
            .replace(/```\s*$/i, '')
            .trim();

        if (!editor) {
            showToast('Editor is loading...');
            return;
        }

        setCode(cleaned);
        showToast('Code generated!', 'success');
    } catch (err) {
        console.error('[Gemini]', err);
        showToast(err.message || 'Generation failed');
    } finally {
        setOverlayActive(false);
        btn.classList.remove('loading');
        startCooldown(btn, btnLabel);
    }
}

function copyCode() {
    const code = getCode().trim();
    if (!code) {
        showToast('Code is empty');
        return;
    }
    navigator.clipboard.writeText(code).then(() => {
        showToast('Code copied to clipboard!', 'success');
    }).catch(() => {
        showToast('Failed to copy code');
    });
}

function downloadCode() {
    const code = getCode().trim();
    if (!code) {
        showToast('Code is empty');
        return;
    }
    const blob = new Blob([code], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'generated_code.lua';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    showToast('File downloaded!', 'success');
}

window.setActive = setActive;
window.toggleTheme = toggleTheme;
window.toggleDropdown = toggleDropdown;
window.toggleActionDropdown = toggleActionDropdown;
window.selectModel = selectModel;
window.selectAction = selectAction;
window.generateCode = generateCode;
window.copyCode = copyCode;
window.downloadCode = downloadCode;

lucide.createIcons();
mountMonaco();
