import { NextRequest, NextResponse } from "next/server";

const ALLOWED_DOMAINS = [
  "work.ink",
  "lootdest.org",
  "loot-links.com",
  "loot-link.com",
  "links.lootlabs.gg",
  "rekonise.com",
  "lockr.so",
  "shrtslug.biz",
  "biovetro.net",
  "technons.com",
  "yrtourguide.com",
  "tournguide.com",
];

export async function GET(request: NextRequest) {
  const url = request.nextUrl.searchParams.get("url");

  if (!url) {
    return NextResponse.json({ error: "Missing url" }, { status: 400 });
  }

  try {
    const targetUrl = new URL(url);
    const isAllowed = ALLOWED_DOMAINS.some(domain =>
      targetUrl.hostname === domain || targetUrl.hostname.endsWith(`.${domain}`)
    );

    if (!isAllowed) {
      return NextResponse.json({ error: "Domain not allowed" }, { status: 403 });
    }

    const response = await fetch(url, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
      },
    });
    const html = await response.text();
    return new NextResponse(html, {
      headers: { "Content-Type": "text/html" },
    });
  } catch (error: any) {
    return NextResponse.json({ error: error.message || "Fetch failed" }, { status: 500 });
  }
}
