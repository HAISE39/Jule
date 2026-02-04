# VELLIXAO Modding Tools - Android

This repository contains modding scripts and templates for Android games using Game Guardian.

## Android Game Guardian Template (Java Heap)
The file `gg_mod_menu.lua` is a Lua script template for **Game Guardian** on Android. It is specifically designed to target the **Java Heap (dalvik-main)** memory region.

### How to Use (English)
1. **Prerequisites**: Install [Game Guardian](https://gameguardian.net/) on your rooted Android device or virtual environment.
2. **Open the Game**: Start the game you want to mod (specifically Java-based games like simple 2D games or those not using JNI/Native code).
3. **Open Game Guardian**: Select the game process.
4. **Load Script**:
   - Click the "Execute Script" (Play) icon in Game Guardian.
   - Select `gg_mod_menu.lua`.
5. **Memory Region**: The script automatically sets the search range to **Java Heap**.
6. **Search & Edit**: Use the menu to search for values (Dword for integers, Float for decimals) and edit them.

### Cara Penggunaan (Indonesian)
1. **Prasyarat**: Instal [Game Guardian](https://gameguardian.net/) di perangkat Android yang sudah di-root atau lingkungan virtual.
2. **Buka Game**: Jalankan game yang ingin di-mod (terutama game berbasis Java/ART yang tidak menggunakan JNI/Native).
3. **Buka Game Guardian**: Pilih proses game tersebut.
4. **Jalankan Script**:
   - Klik ikon "Execute Script" (Play) di Game Guardian.
   - Pilih file `gg_mod_menu.lua`.
5. **Region Memori**: Script ini secara otomatis mengatur jangkauan pencarian ke **Java Heap (dalvik-main)**.
6. **Cari & Ubah**: Gunakan menu yang muncul untuk mencari nilai (Dword untuk angka bulat, Float untuk angka desimal) dan mengubahnya.

---

## Why Java Heap?
Most modern Android games use C++ (JNI) via engines like Unity (il2cpp) or Unreal. However, some games (and older ones) store their logic and values in the **Dalvik/ART Heap**.
- **dalvik-main**: This is the primary region where Java objects are stored.
- **bukan JNI**: This template is ideal for games where values are not found in the `Anonymous` or `C++ Heap` regions.
