import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get("url");

  if (!url) {
    return NextResponse.json({ error: "URL is required" }, { status: 400 });
  }

  try {
    // Attempting to use a known public bypass API
    // Note: Some APIs require specific headers or keys.
    // This is a proxy to keep the logic server-side and avoid CORS.
    const apiResponse = await fetch(`https://api.adbypass.org/bypass?url=${encodeURIComponent(url)}`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      },
    });

    if (!apiResponse.ok) {
        // Fallback or specific error handling
        return NextResponse.json({ error: "Failed to bypass link. The provider might be temporarily down." }, { status: 500 });
    }

    const data = await apiResponse.json();

    // The adbypass.org API usually returns { success: true, data: { destination: "..." } }
    // or similar. Adjusting to common response formats.
    if (data.destination || data.url || (data.data && data.data.destination)) {
        return NextResponse.json({
            success: true,
            destination: data.destination || data.url || data.data.destination
        });
    }

    return NextResponse.json({ error: "Could not find destination link in response." }, { status: 500 });
  } catch (error) {
    console.error("Bypass API Error:", error);
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
