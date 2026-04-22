import * as admin from "firebase-admin";

if (!admin.apps.length) {
  if (process.env.FIREBASE_PROJECT_ID) {
    try {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
          privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n"),
        }),
      });
    } catch (error) {
      console.error("Firebase admin initialization error", error);
    }
  } else {
    console.warn("Firebase Admin: FIREBASE_PROJECT_ID is not set. Skipping initialization.");
  }
}

export const adminDb = admin.apps.length ? admin.firestore() : null;
export const adminField = admin.firestore.FieldValue;
