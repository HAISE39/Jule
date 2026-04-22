"use server";

import { adminDb } from "@/lib/firebase-admin";
import { revalidatePath } from "next/cache";

export type Token = {
  id: string;
  token: string;
  type: "permanent" | "expired";
  expirationDate: string | null;
  maxUsage: number;
  currentUsage: number;
  createdAt: number;
};

export async function getTokens() {
  if (!adminDb) return [];
  const snapshot = await adminDb.collection("tokens").orderBy("createdAt", "desc").get();
  return snapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data(),
  })) as Token[];
}

export async function createToken(formData: FormData) {
  if (!adminDb) return;
  const token = formData.get("token") as string;
  const type = formData.get("type") as "permanent" | "expired";
  const expirationDate = formData.get("expirationDate") as string;
  const maxUsage = parseInt(formData.get("maxUsage") as string);

  await adminDb.collection("tokens").add({
    token,
    type,
    expirationDate: type === "expired" ? expirationDate : null,
    maxUsage,
    currentUsage: 0,
    createdAt: Date.now(),
  });

  revalidatePath("/dashboard");
}

export async function updateToken(id: string, formData: FormData) {
  if (!adminDb) return;
  const token = formData.get("token") as string;
  const type = formData.get("type") as "permanent" | "expired";
  const expirationDate = formData.get("expirationDate") as string;
  const maxUsage = parseInt(formData.get("maxUsage") as string);
  const currentUsage = parseInt(formData.get("currentUsage") as string);

  await adminDb.collection("tokens").doc(id).update({
    token,
    type,
    expirationDate: type === "expired" ? expirationDate : null,
    maxUsage,
    currentUsage,
  });

  revalidatePath("/dashboard");
}

export async function deleteToken(id: string) {
  if (!adminDb) return;
  await adminDb.collection("tokens").doc(id).delete();
  revalidatePath("/dashboard");
}
