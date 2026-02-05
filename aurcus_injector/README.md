# Aurcus Online Injector (AndLua+)

This is a full source code for an injector and mod menu for the game **Aurcus Online** (`com.asobimo.aurcusonline.wx`), developed for the **AndLua+** platform.

## Features
- **Auto-Launch Game**: Automatically starts the game when the injector is activated.
- **Floating Mod Menu**: A draggable floating window that stays on top of the game.
- **Dalvik-Main Search**: Specifically targets the `java_heap` (`dalvik-main`) memory region as requested.
- **Non-Root Support**: Designed to work using the `sharedUserId` and `debug` method.

## Requirements
To make this injector work without root:
1. Both the Injector app and the Game app must have the same `android:sharedUserId` in their `AndroidManifest.xml`.
2. Both apps must be signed with the same certificate.
3. For best results, they should share the same process by adding `android:process=":shared"` (or similar) to their `<application>` tag.
4. The Injector requires "Display over other apps" (Overlay) permission.

## Files
- `main.lua`: Main application logic and UI.
- `layout.aly`: UI layout for the main screen.
- `float.lua`: Floating window and mod menu logic.
- `memory.lua`: Memory manipulation utility.

---

# Injector Aurcus Online (AndLua+)

Ini adalah kode sumber lengkap untuk injector dan menu mod game **Aurcus Online** (`com.asobimo.aurcusonline.wx`), dikembangkan untuk platform **AndLua+**.

## Fitur
- **Auto-Launch Game**: Secara otomatis menjalankan game saat injector diaktifkan.
- **Floating Mod Menu**: Jendela melayang yang dapat digeser dan tetap berada di atas game.
- **Pencarian Dalvik-Main**: Secara khusus menargetkan wilayah memori `java_heap` (`dalvik-main`) sesuai permintaan.
- **Dukungan Tanpa Root**: Dirancang untuk bekerja menggunakan metode `sharedUserId` dan `debug`.

## Persyaratan
Untuk membuat injector ini berfungsi tanpa root:
1. Aplikasi Injector dan aplikasi Game harus memiliki `android:sharedUserId` yang sama di `AndroidManifest.xml` mereka.
2. Kedua aplikasi harus ditandatangani dengan sertifikat (signature) yang sama.
3. Untuk hasil terbaik, mereka harus berbagi proses yang sama dengan menambahkan `android:process=":shared"` (atau serupa) ke tag `<application>` mereka.
4. Injector memerlukan izin "Tampilkan di atas aplikasi lain" (Overlay).

## Berkas
- `main.lua`: Logika dan UI aplikasi utama.
- `layout.aly`: Tata letak UI untuk layar utama.
- `float.lua`: Logika jendela melayang dan menu mod.
- `memory.lua`: Alat bantu manipulasi memori.
