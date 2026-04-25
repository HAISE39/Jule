import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get("url");

  if (!url) {
    return NextResponse.json({ error: "URL is required" }, { status: 400 });
  }

  // Domain detection
  const isLinkvertise = url.includes("linkvertise.com") || url.includes("link-to.net") || url.includes("direct-link.net");
  const isWorkInk = url.includes("work.ink");

  const providers = [
    {
      name: "EvadeAPI_LV",
      condition: isLinkvertise,
      url: (u: string) => "https://skipped.lol/api/evade/lv",
      method: "POST",
      headers: { "Content-Type": "application/json" } as Record<string, string>,
      body: (u: string) => ({ URL: u, userAndHash: "" })
    },
    {
        name: "EvadeAPI_WorkInk",
        condition: isWorkInk,
        url: (u: string) => "https://skipped.lol/api/evade/init",
        method: "POST",
        headers: { "Content-Type": "application/json" } as Record<string, string>,
        body: (u: string) => ({ mcl: "", session_id: Math.random().toString(36).substring(2, 15) })
    },
    {
        name: "ADBypass",
        condition: true,
        url: (u: string) => `https://api2.adbypass.org/bypass?url=${encodeURIComponent(u)}`,
        method: "GET",
        headers: {
          "Referer": "https://adbypass.org/",
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        } as Record<string, string>
    }
  ];

  for (const provider of providers) {
    if (provider.condition === false) continue;

    try {
      const fetchUrl = typeof provider.url === "function" ? provider.url(url) : provider.url;
      const options: RequestInit = {
        method: provider.method,
        headers: provider.headers,
        next: { revalidate: 0 }
      };

      if (provider.method === "POST" && "body" in provider) {
          options.body = JSON.stringify(provider.body!(url));
      }

      const apiResponse = await fetch(fetchUrl, options);

      if (apiResponse.ok) {
        const data = await apiResponse.json();

        // Handle EvadeAPI responses
        if (provider.name.startsWith("EvadeAPI")) {
            if (data.type === "url" && data.resp) {
                return NextResponse.json({ success: true, destination: data.resp, provider: provider.name });
            }
            if (data.type === "paste" && data.resp) {
                 return NextResponse.json({ success: true, destination: data.resp, provider: provider.name, type: "paste" });
            }
            // For WorkInk init, it might return a token or session info, but usually Evade handles the WS.
            // Since we are a server-side proxy, we might not be able to do the full WS handshake easily.
            // But we can at least try to get the destination if the API provides it.
            if (data.destinationURL) {
                return NextResponse.json({ success: true, destination: data.destinationURL, provider: provider.name });
            }
            continue;
        }

        // Handle ADBypass response format
        const destination = data.destination || data.url || (data.data && data.data.destination) || data.result;
        if (destination && typeof destination === "string" && destination.startsWith("http")) {
          return NextResponse.json({ success: true, destination: destination, provider: provider.name });
        }
      }
    } catch (error) {
      console.error(`${provider.name} error:`, error);
    }
  }

  return NextResponse.json({
    error: "Automated bypass failed. This link might require manual verification.",
    fallback: true
  }, { status: 502 });
}
