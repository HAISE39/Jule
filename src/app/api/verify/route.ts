import { adminDb, adminField } from "@/lib/firebase-admin";
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const { token } = await request.json();

    if (!token) {
      return NextResponse.json({ success: false, message: "Token is required" }, { status: 400 });
    }

    if (!adminDb) {
      return NextResponse.json({ success: false, message: "Server configuration error" }, { status: 500 });
    }

    const snapshot = await adminDb.collection("tokens").where("token", "==", token).limit(1).get();

    if (snapshot.empty) {
      return NextResponse.json({ success: false, message: "Invalid token" }, { status: 404 });
    }

    const tokenDoc = snapshot.docs[0];
    const tokenData = tokenDoc.data();

    // Check expiration
    if (tokenData.type === "expired" && tokenData.expirationDate) {
      const expirationDate = new Date(tokenData.expirationDate);
      if (new Date() > expirationDate) {
        return NextResponse.json({ success: false, message: "Token has expired" }, { status: 403 });
      }
    }

    // Check usage
    if (tokenData.currentUsage >= tokenData.maxUsage) {
      return NextResponse.json({ success: false, message: "Token usage limit reached" }, { status: 403 });
    }

    // Increment usage
    await tokenDoc.ref.update({
      currentUsage: adminField.increment(1),
    });

    return NextResponse.json({ success: true, message: "Token verified successfully" });
  } catch (error) {
    console.error("Verification error:", error);
    return NextResponse.json({ success: false, message: "Internal server error" }, { status: 500 });
  }
}
