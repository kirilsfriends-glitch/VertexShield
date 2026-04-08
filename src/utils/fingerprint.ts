export function getDeviceFingerprint(): string {
  let fingerprint = localStorage.getItem("device_fingerprint");
  if (!fingerprint) {
    fingerprint = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    localStorage.setItem("device_fingerprint", fingerprint);
  }
  return fingerprint;
}

export async function getClientIp(): Promise<string> {
  try {
    const response = await fetch("https://api.ipify.org?format=json");
    const data = await response.json();
    return data.ip;
  } catch (error) {
    console.error("Error fetching IP:", error);
    return "unknown";
  }
}
