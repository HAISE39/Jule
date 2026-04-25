import { NextRequest, NextResponse } from "next/server";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  try {
    const apiResponse = await fetch(`https://api2.adbypass.org/long-lived/${id}/status`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Referer": "https://bypass.city/",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
      },
      next: { revalidate: 0 }
    });

    const data = await apiResponse.json();
    return NextResponse.json(data, { status: apiResponse.status });
  } catch (error) {
    console.error("Long-lived proxy error:", error);
    return NextResponse.json({ message: "Internal Server Error", error: "Proxy Failed" }, { status: 500 });
  }
}
