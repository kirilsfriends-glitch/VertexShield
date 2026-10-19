// ⚠️ ВОССОЗДАННАЯ ЗАГЛУШКА — НЕ ОРИГИНАЛЬНЫЙ КОД.
// Оригинальный исходник серверной функции /api/request утерян вместе с репозиторием
// (Vercel отдаёт только скомпилированную функцию, исходники с боевого сайта не получить).
// Контракт воспроизведён по фронтенду (см. callGeminiAPI в main_script.js):
//   POST /api/request.php  (редиректится на /api/request — см. vercel.json)
//   тело: { prompt: string, action: string, currentCode: string }
//   ответ: text/plain — готовый Lua-код или текст ошибки.
// Для реальной генерации задайте переменную окружения GEMINI_API_KEY.

const DEFAULT_MODEL = process.env.GEMINI_MODEL || 'gemini-2.0-flash';

const SYSTEM_PROMPT = [
  'You are a Lua code generator for Roblox (Luau) scripts.',
  'Return ONLY the Lua code, without markdown fences and without commentary.',
  'The code must be valid Luau and ready to run in a Roblox executor or Script.',
].join(' ');

function buildUserText({ prompt, action, currentCode }) {
  if (action === 'Modify current script') {
    return [
      'Modify the current Lua script according to the request.',
      '',
      'REQUEST:',
      prompt,
      '',
      'CURRENT SCRIPT:',
      currentCode || '(empty)',
    ].join('\n');
  }
  return `Generate a new Lua script according to this request:\n\n${prompt}`;
}

module.exports = async function handler(req, res) {
  if (req.method !== 'POST') {
    res.status(405).type('text/plain').send('Method not allowed');
    return;
  }

  const { prompt, action, currentCode } = req.body || {};
  if (!prompt || typeof prompt !== 'string') {
    res.status(400).type('text/plain').send('Missing "prompt" in request body');
    return;
  }

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    // Заглушка, чтобы фронтенд работал и без ключа.
    res.status(200).type('text/plain').send(
      '-- Lua Code Generator (stub): GEMINI_API_KEY is not set on the server.\n' +
      `-- Action: ${action || 'Generate new script'}\n` +
      `-- Prompt: ${prompt}\n` +
      'print("Hello from Lua Code Generator!")\n'
    );
    return;
  }

  try {
    const url =
      'https://generativelanguage.googleapis.com/v1beta/models/' +
      encodeURIComponent(DEFAULT_MODEL) +
      ':generateContent?key=' +
      encodeURIComponent(apiKey);

    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        systemInstruction: { parts: [{ text: SYSTEM_PROMPT }] },
        contents: [{ role: 'user', parts: [{ text: buildUserText({ prompt, action, currentCode }) }] }],
        generationConfig: { temperature: 0.7, maxOutputTokens: 4096 },
      }),
    });

    const data = await response.json();
    if (!response.ok) {
      const message = (data && data.error && data.error.message) || response.statusText;
      res.status(502).type('text/plain').send('API error: ' + message);
      return;
    }

    const parts =
      data.candidates && data.candidates[0] && data.candidates[0].content
        ? data.candidates[0].content.parts || []
        : [];
    const text = parts.map((p) => p.text || '').join('');
    if (!text.trim()) {
      res.status(502).type('text/plain').send('API returned an empty response');
      return;
    }

    res.status(200).type('text/plain').send(text);
  } catch (err) {
    res.status(500).type('text/plain').send('Server error: ' + (err && err.message ? err.message : String(err)));
  }
};
