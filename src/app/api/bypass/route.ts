import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { endpoint, ...data } = body;

    if (!endpoint) {
      return NextResponse.json({ error: "Missing endpoint" }, { status: 400 });
    }

    const targetUrl = `https://skipped.lol/api/evade/${endpoint}`;

    // We try to get the cookie first if needed, but here we just try the request
    const response = await fetch(targetUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Origin": "https://linkvertise.com",
        "Referer": "https://linkvertise.com/",
      },
      body: JSON.stringify(data),
    });

    const result = await response.json();
    return NextResponse.json(result);
  } catch (error: any) {
    // If it's a redirect or anti-bot issue, we might get an error here
    console.error("Proxy POST error:", error);
    return NextResponse.json({ error: "Bypass API unreachable. Anti-bot protection (DiamWall) may be blocking the request.", details: error.message }, { status: 502 });
  }
}

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const endpoint = searchParams.get("endpoint");

  if (!endpoint) {
    return NextResponse.json({ error: "Missing endpoint" }, { status: 400 });
  }

  const targetUrl = new URL(`https://skipped.lol/api/evade/${endpoint}`);
  searchParams.forEach((value, key) => {
    if (key !== "endpoint") {
      targetUrl.searchParams.append(key, value);
    }
  });

  try {
    const response = await fetch(targetUrl.toString(), {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
      },
    });

    const result = await response.json();
    return NextResponse.json(result);
  } catch (error: any) {
    console.error("Proxy GET error:", error);
    return NextResponse.json({ error: "Bypass API unreachable.", details: error.message }, { status: 502 });
  }
}
