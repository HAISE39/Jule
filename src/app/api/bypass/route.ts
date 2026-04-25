import { NextRequest, NextResponse } from "next/server";

/**
 * XOR Decryption logic as provided in the script.
 */
function decryptUrl(encoded: string): string | null {
  try {
    const raw = Buffer.from(encoded, 'base64').toString('binary');
    const key = raw.substring(0, 5);
    const content = raw.substring(5);
    let result = '';

    for (let i = 0; i < content.length; i++) {
      result += String.fromCharCode(content.charCodeAt(i) ^ key.charCodeAt(i % 5));
    }
    return result.includes('http') ? result : null;
  } catch (err) {
    return null;
  }
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get("url");

  if (!url) {
    return NextResponse.json({ error: "URL is required" }, { status: 400 });
  }

  try {
    // 1. Initial Request to the LootLabs page to get the slug/ID
    // Example LootLabs URL: https://lootlabs.gg/S0lV (slug is S0lV)
    const urlObj = new URL(url);
    const slug = urlObj.searchParams.get("fJjn") !== null ? "fJjn" : urlObj.pathname.split('/').pop();
    const dataParam = urlObj.searchParams.get("data") || urlObj.searchParams.get("d");

    if (dataParam) {
      const decrypted = decryptUrl(dataParam);
      if (decrypted && decrypted.includes('http')) {
        return NextResponse.json({ destination: decrypted });
      }
    }

    if (!slug) {
        return NextResponse.json({ error: "Invalid LootLabs URL" }, { status: 400 });
    }

    // Since we are running on the server, we can't easily hook WebSockets like the userscript.
    // However, the userscript also mentions Fetch hooks for 'data.url' or 'data.link'.
    // Usually, LootLabs makes a POST request to their API with the slug.

    const apiBase = "https://api.lootlabs.gg";

    // We try to simulate the behavior.
    // Usually there is a 'handshake' or 'sync' call.
    // Given the script logic, it mostly intercepts what the site receives.

    // Let's try to fetch the page and see if we can find any clues or if there's a simpler public API.
    // NOTE: Real bypass usually involves more complex session handling.
    // But since the user wants it "like the script", we focus on the decryption and interception.

    const response = await fetch(`${apiBase}/v1/loot/slug?slug=${slug}`, {
        headers: {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Origin": "https://lootlabs.gg",
            "Referer": "https://lootlabs.gg/"
        }
    });

    if (!response.ok) {
        throw new Error("LootLabs API error");
    }

    const data = await response.json();

    // The script expects r: prefix for XOR encrypted URLs in WebSockets
    // or direct data.url/link/destination in fetch responses.

    let destination = data.url || data.link || data.destination;

    // If it's encrypted (not common in direct JSON but possible in some fields)
    if (typeof destination === 'string' && !destination.includes('http')) {
        const decrypted = decryptUrl(destination);
        if (decrypted) destination = decrypted;
    }

    if (destination && typeof destination === 'string' && destination.includes('http')) {
        return NextResponse.json({ destination });
    }

    // If not found in initial fetch, maybe it's in a sub-task or requires a wait.
    // For this demonstration, we'll return an error if not immediately found.
    return NextResponse.json({
        message: "Link not found immediately. This version supports instant snipes.",
        error: "Not sniped"
    }, { status: 404 });

  } catch (error) {
    console.error("Bypass error:", error);
    return NextResponse.json({ message: "Bypass failed", error: String(error) }, { status: 500 });
  }
}
