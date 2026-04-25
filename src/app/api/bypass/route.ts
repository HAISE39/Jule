import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get("url");

  if (!url) {
    return NextResponse.json({ error: "URL is required" }, { status: 400 });
  }

  // Since most public APIs are restricted or unstable, we try a few known patterns.
  // Many bypassers now require client-side solving (Turnstile/hCaptcha),
  // so a server-side proxy is inherently limited.
  const providers = [
    {
      name: "ADBypass",
      url: (u: string) => `https://api2.adbypass.org/bypass?url=${encodeURIComponent(u)}`,
      method: "GET",
      headers: {
        "Referer": "https://adbypass.org/",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      }
    }
  ];

  for (const provider of providers) {
    try {
      const options: RequestInit = {
        method: provider.method,
        headers: provider.headers,
        next: { revalidate: 0 } // Don't cache failures
      };

      const fetchUrl = typeof provider.url === "function" ? provider.url(url) : provider.url;
      const apiResponse = await fetch(fetchUrl, options);

      if (apiResponse.ok) {
        const data = await apiResponse.json();
        const destination = data.destination || data.url || (data.data && data.data.destination) || data.result;

        if (destination && typeof destination === "string" && destination.startsWith("http")) {
          return NextResponse.json({
            success: true,
            destination: destination,
            provider: provider.name
          });
        }
      }
    } catch (error) {
      console.error(`${provider.name} error:`, error);
    }
  }

  // If all providers fail, return a 502 with instructions for the UI to show a fallback
  return NextResponse.json({
    error: "Automated bypass failed. This link might require manual verification.",
    fallback: true
  }, { status: 502 });
}
