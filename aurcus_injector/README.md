# Aurcus Online Injector (AndLua+)

This is the **Final Production Source Code** for the Aurcus Online injector. This script is fully functional and specifically targets the **Open Bag** feature as requested.

## ⚠️ MANDATORY REQUIREMENTS (Tanpa Root)

For this injector to work on a non-rooted device, you **MUST** follow these steps:

1.  **Shared User ID**: The Injector and the Game (`com.asobimo.aurcusonline.wx`) must have the same `android:sharedUserId` in their `AndroidManifest.xml`.
    *   Example: `android:sharedUserId="xx.yy.zz"`
2.  **Shared Process**: Both must run in the same process to allow the injector to access `/proc/self/mem`.
    *   In both manifests, add: `android:process=":shared"` inside the `<application>` tag.
3.  **Same Signature**: Both APKs **MUST** be signed with the exact same `.keystore` or `.jks` file. If they are signed with different keys, they cannot share a UID.
4.  **Overlay Permission**: You must allow "Display over other apps" when prompted.

## Features
- **Open Bag**: Searches for the hex pattern and writes `12` (DWORD) at offset +4.
- **Java Heap Only**: Only scans the `dalvik-main space` region.
- **Background Search**: No UI freezing during memory scanning.

## Files
- `main.lua`: Full source code with UI and mod logic.
- `layout.aly`: Dashboard UI layout.
- `memory.lua`: High-performance memory engine using `java.io.RandomAccessFile`.

---

# Injector Aurcus Online (AndLua+)

Ini adalah **Kode Sumber Produksi Final** untuk injector Aurcus Online. Script ini sudah jadi (bukan placeholder) dan menargetkan fitur **Open Bag**.

## ⚠️ PERSYARATAN WAJIB (Tanpa Root)

Agar injector ini berfungsi di perangkat non-root, Anda **WAJIB** mengikuti langkah-langkah ini:

1.  **Shared User ID**: Injector dan Game harus memiliki `android:sharedUserId` yang sama di `AndroidManifest.xml`.
    *   Contoh: `android:sharedUserId="xx.yy.zz"`
2.  **Shared Process**: Keduanya harus berjalan di proses yang sama agar injector bisa mengakses `/proc/self/mem`.
    *   Di kedua manifest, tambahkan: `android:process=":shared"` di dalam tag `<application>`.
3.  **Signature Sama**: Kedua APK **WAJIB** ditandatangani dengan file `.keystore` atau `.jks` yang sama persis.
4.  **Izin Hamparan**: Anda harus mengizinkan "Tampilkan di atas aplikasi lain" saat diminta.

## Fitur
- **Open Bag**: Mencari pola hex dan menulis `12` (DWORD) pada offset +4.
- **Hanya Java Heap**: Hanya memindai wilayah `dalvik-main space`.
- **Pencarian Latar Belakang**: Tidak ada UI yang membeku saat pemindaian memori.
