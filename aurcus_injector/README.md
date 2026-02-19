# Aurcus Online Injector (AndLua+)

This is the **Final Production Source Code** for the Aurcus Online injector. This script is fully functional and specifically targets the **Inject Sword** feature as requested.

## ⚠️ MANDATORY REQUIREMENTS (Tanpa Root)

For this injector to work on a non-rooted device, you **MUST** follow these steps:

1.  **Shared User ID**: The Injector and the Game (`com.asobimo.aurcusonline.wx`) must have the same `android:sharedUserId` in their `AndroidManifest.xml`.
    *   Example: `android:sharedUserId="xx.yy.zz"`
2.  **Shared Process**: Both must run in the same process to allow the injector to access `/proc/self/mem`.
    *   In both manifests, add: `android:process=":shared"` inside the `<application>` tag.
3.  **Same Signature**: Both APKs **MUST** be signed with the exact same `.keystore` or `.jks` file. If they are signed with different keys, they cannot share a UID.
4.  **Overlay Permission**: You must allow "Display over other apps" when prompted.

## Features
- **Inject Sword**: Searches for the pattern `3;30;1;2;1` (DWORDs) and writes `99999` to offsets 24, 28, 32, and 36 relative to the `30` anchor.
- **Java Heap Only**: Specifically scans the `dalvik-main space` region to match GameGuardian behavior.
- **Background Search**: Memory scanning is performed in a background thread to prevent UI freezing.

## Files
- `main.lua`: Full source code with UI and mod logic.
- `layout.aly`: Dashboard UI layout.
- `memory.lua`: High-performance memory engine using `java.io.RandomAccessFile`.

---

# Injector Aurcus Online (AndLua+)

Ini adalah **Kode Sumber Produksi Final** untuk injector Aurcus Online. Script ini sudah jadi (bukan placeholder) dan menargetkan fitur **Injek Pedang**.

## ⚠️ PERSYARATAN WAJIB (Tanpa Root)

Agar injector ini berfungsi di perangkat non-root, Anda **WAJIB** mengikuti langkah-langkah ini:

1.  **Shared User ID**: Injector dan Game harus memiliki `android:sharedUserId` yang sama di `AndroidManifest.xml`.
    *   Contoh: `android:sharedUserId="xx.yy.zz"`
2.  **Shared Process**: Keduanya harus berjalan di proses yang sama agar injector bisa mengakses `/proc/self/mem`.
    *   Di kedua manifest, tambahkan: `android:process=":shared"` di dalam tag `<application>`.
3.  **Signature Sama**: Kedua APK **WAJIB** ditandatangani dengan file `.keystore` atau `.jks` yang sama persis.
4.  **Izin Hamparan**: Anda harus mengizinkan "Tampilkan di atas aplikasi lain" saat diminta.

## Fitur
- **Injek Pedang**: Mencari pola `3;30;1;2;1` (DWORD) dan menulis `99999` pada offset 24, 28, 32, dan 36 relatif terhadap nilai `30`.
- **Hanya Java Heap**: Memindai wilayah `dalvik-main space` sesuai perilaku GameGuardian.
- **Pencarian Latar Belakang**: Tidak ada UI yang membeku saat pemindaian memori.
