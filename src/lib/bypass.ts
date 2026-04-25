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

async function tryBypassCity(url: string) {
    try {
        const res = await fetch(`https://api.bypass.city/bypass?url=${encodeURIComponent(url)}`);
        const data = await res.json();
        return data.destination || null;
    } catch {
        return null;
    }
}

async function tryAdLinkFly(url: string) {
    try {
        // Example of another public bypass API if it exists
        const res = await fetch(`https://free-bypass.vercel.app/api/bypass?url=${encodeURIComponent(url)}`);
        const data = await res.json();
        return data.bypassed_url || data.destination || null;
    } catch {
        return null;
    }
}

export async function bypassLinkvertise(url: string, onStatus: OnStatusUpdate) {
  onStatus({ message: "Safety delay active (5s)...", type: 'info' });
  await sleep(5000);

  try {
    onStatus({ message: "Bypassing Linkvertise (Method 1)...", type: 'info' });
    const dest1 = await tryBypassCity(url);
    if (dest1) {
        onStatus({ message: "Bypass complete!", type: 'success', destination: dest1 });
        return;
    }

    onStatus({ message: "Method 1 failed, trying Method 2...", type: 'info' });
    const res = await fetch('/api/bypass', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        endpoint: 'lv',
        URL: url
      })
    });
    const data = await res.json();

    if (data.resp && data.type === 'url') {
        onStatus({ message: "Bypass complete!", type: 'success', destination: data.resp });
    } else if (data.resp && data.type === 'paste') {
        onStatus({ message: "Bypass complete!", type: 'success', content: data.resp });
    } else {
        const dest2 = await tryAdLinkFly(url);
        if (dest2) {
            onStatus({ message: "Bypass complete!", type: 'success', destination: dest2 });
        } else {
            throw new Error("All bypass methods failed.");
        }
    }
  } catch (error: any) {
    onStatus({ message: `Bypass failed. The external APIs are likely protected or down. Please use the userscript directly on the page.`, type: 'error' });
  }
}

export async function startBypass(url: string, onStatus: OnStatusUpdate) {
  const provider = identifyProvider(url);

  switch (provider) {
    case 'linkvertise':
      await bypassLinkvertise(url, onStatus);
      break;
    case 'rekonise':
        onStatus({ message: "Rekonise bypass usually requires social action completion. Best handled by the userscript.", type: 'info' });
        break;
    case 'unknown':
      onStatus({ message: "Provider not supported or invalid URL.", type: 'error' });
      break;
    default:
      onStatus({
        message: `${provider} bypass requires real-time browser interaction (WebSockets/Cookies) which is best handled by the userscript on the target page.`,
        type: 'info'
      });
  }
}
