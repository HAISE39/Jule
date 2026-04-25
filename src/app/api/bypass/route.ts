import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get("url");
  const token = searchParams.get("token") || "";
  const provider = searchParams.get("provider") || "TURNSTILE";

  if (!url) {
    return NextResponse.json({ error: "URL is required" }, { status: 400 });
  }

  try {
    const apiResponse = await fetch("https://api2.adbypass.org/bypass", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Referer": "https://bypass.city/",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "token": token,
        "x-captcha-provider": provider
      },
      body: JSON.stringify({ url }),
      next: { revalidate: 0 }
    });

    const data = await apiResponse.json();
    return NextResponse.json(data, { status: apiResponse.status });
  } catch (error) {
    console.error("Proxy error:", error);
    return NextResponse.json({ message: "Internal Server Error", error: "Proxy Failed" }, { status: 500 });
  }
}
