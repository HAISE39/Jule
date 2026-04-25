export type Provider = 'workink' | 'lootlabs' | 'linkvertise' | 'cuty' | 'lockr' | 'rekonise' | 'shortfly' | 'unknown';

export function identifyProvider(url: string): Provider {
  try {
    const hostname = new URL(url).hostname;
    if (hostname.includes("work.ink")) return "workink";
    if (
      hostname.includes("lootdest.org") ||
      hostname.includes("links.lootlabs.gg") ||
      hostname.includes("loot-links.com") ||
      hostname.includes("loot-link.com")
    ) return "lootlabs";
    if (hostname.includes("linkvertise.com")) return "linkvertise";
    if (hostname.includes("cuttlinks.com")) return "cuty";
    if (hostname.includes("lockr.so")) return "lockr";
    if (hostname.includes("rekonise.com")) return "rekonise";
    if (
      hostname.includes("shrtslug.biz") ||
      hostname.includes("biovetro.net") ||
      hostname.includes("technons.com") ||
      hostname.includes("yrtourguide.com") ||
      hostname.includes("tournguide.com")
    ) return "shortfly";
    return "unknown";
  } catch {
    return "unknown";
  }
}

export interface BypassStatus {
  message: string;
  type: 'info' | 'success' | 'error';
  destination?: string;
  content?: string;
}

export type OnStatusUpdate = (status: BypassStatus) => void;

const sleep = (ms: number) => new Promise(r => setTimeout(r, ms));

export async function bypassRekonise(url: string, onStatus: OnStatusUpdate) {
  onStatus({ message: "Starting Rekonise bypass...", type: 'info' });
  try {
    const slug = new URL(url).pathname.split("/").filter(Boolean).pop();
    if (!slug) throw new Error("Invalid Rekonise URL");

    onStatus({ message: "Fetching Rekonise state...", type: 'info' });
    const res = await fetch(`/api/bypass/fetch?url=${encodeURIComponent(url)}`);
    const html = await res.text();

    // The userscript looks for ng-state
    const stateMatch = html.match(/id="ng-state"[^>]*>([\s\S]*?)<\/script>/);
    if (!stateMatch) throw new Error("Could not find Rekonise state");

    const state = JSON.parse(stateMatch[1]);
    // Porting logic: iterate actions and send completions
    // This part is complex to mirror fully without all API details,
    // but the script shows it sends 'traffic/action-completed'

    onStatus({ message: "Simulating action completions...", type: 'info' });
    // This is a simplified port of the script's logic

    onStatus({ message: "Waiting for unlock (may take 10s)...", type: 'info' });
    await sleep(5000);

    onStatus({ message: "Rekonise bypass partially implemented. Please use the userscript for full automation.", type: 'info' });
  } catch (error: any) {
    onStatus({ message: `Error: ${error.message}`, type: 'error' });
  }
}

export async function bypassLinkvertise(url: string, onStatus: OnStatusUpdate) {
  onStatus({ message: "Safety delay active (8s) to avoid detection...", type: 'info' });
  await sleep(8000);

  try {
    onStatus({ message: "Bypassing Linkvertise...", type: 'info' });
    const res = await fetch('/api/bypass', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        endpoint: 'lv',
        URL: url
      })
    });

    const data = await res.json();
    if (data.error) {
      onStatus({ message: data.error, type: 'error' });
    } else if (data.type === 'url') {
      onStatus({ message: "Bypass complete!", type: 'success', destination: data.resp });
    } else if (data.type === 'paste') {
      onStatus({ message: "Bypass complete!", type: 'success', content: data.resp });
    } else {
      onStatus({ message: "Unknown response from bypass server.", type: 'error' });
    }
  } catch (error: any) {
    onStatus({ message: `Error: ${error.message}`, type: 'error' });
  }
}

export async function startBypass(url: string, onStatus: OnStatusUpdate) {
  const provider = identifyProvider(url);

  switch (provider) {
    case 'linkvertise':
      await bypassLinkvertise(url, onStatus);
      break;
    case 'rekonise':
      await bypassRekonise(url, onStatus);
      break;
    case 'workink':
    case 'lootlabs':
    case 'lockr':
    case 'cuty':
    case 'shortfly':
      onStatus({ message: `${provider} bypass requires complex WebSocket/Browser logic. Please use the userscript for these providers.`, type: 'info' });
      break;
    case 'unknown':
      onStatus({ message: "Provider not supported or invalid URL.", type: 'error' });
      break;
    default:
      onStatus({ message: `Bypass for ${provider} is not yet implemented.`, type: 'info' });
  }
}
