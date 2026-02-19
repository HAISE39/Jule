# VELLIXAO Android Mod Menu - AIDE Pro Template

Template mod menu ini dibuat khusus untuk digunakan di **AIDE Pro** (Android IDE). Script ini menggunakan **Pure Java** (Tanpa JNI/Native C++) dan berfokus pada manipulasi memori di region **Java Heap (dalvik-main)**.

## Fitur
- **Floating Mod Menu**: Menu melayang yang bisa ditarik (draggable).
- **Memory Scanner (Java)**: Mencari nilai Dword (Integer) dan Float langsung di dalam proses game.
- **Java Heap Focus**: Menargetkan `[anon:dalvik-main]` melalui `/proc/self/mem`.
- **Tanpa JNI**: Sangat cocok untuk pemula yang ingin belajar modding APK menggunakan AIDE Pro.

## Struktur Project
- `MainActivity.java`: Mengatur izin overlay dan menjalankan menu.
- `FloatingMenuService.java`: UI dan logika tombol menu.
- `MemoryScanner.java`: Logika inti pencarian dan pengubahan memori.

---

## Cara Penggunaan di AIDE Pro (Indonesian)

1. **Buat Project Baru**: Buka AIDE Pro, buat project Android baru.
2. **Copy File**: Salin ketiga file Java di atas ke folder `app/src/main/java/com/vellixao/modmenu/`.
3. **Edit AndroidManifest.xml**: Tambahkan izin dan deklarasi service berikut:
   ```xml
   <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>

   <application ...>
       <service android:name=".FloatingMenuService" android:enabled="true" android:exported="false"/>
       <activity android:name=".MainActivity">
           <intent-filter>
               <action android:name="android.intent.action.MAIN" />
               <category android:name="android.intent.category.LAUNCHER" />
           </intent-filter>
       </activity>
   </application>
   ```
4. **Build & Install**: Klik tombol Run di AIDE Pro.
5. **Gunakan**: Berikan izin "Display over other apps" saat diminta. Menu akan muncul. Masukkan nilai yang ingin dicari (seperti di Game Guardian) dan nilai barunya, lalu klik tombol Search & Edit.

---

## How to Use in AIDE Pro (English)

1. **Create New Project**: Open AIDE Pro and create a new Android project.
2. **Copy Files**: Place the three Java files into `app/src/main/java/com/vellixao/modmenu/`.
3. **Modify AndroidManifest.xml**: Add the overlay permission and register the service.
4. **Build & Install**: Run the project from AIDE Pro.
5. **Usage**: Grant overlay permissions. Enter the value you want to search for and the replacement value, then click "Search & Edit".

---

## Penjelasan Teknis (Technical Explanation)
Script ini mensimulasikan sistem **Game Guardian** dengan cara:
1. Membaca `/proc/self/maps` untuk menemukan alamat memori bertanda `[anon:dalvik-main]`.
2. Membaca `/proc/self/mem` menggunakan `RandomAccessFile` untuk memindai byte data.
3. Melakukan pencarian byte-per-byte untuk mencocokkan nilai Dword (Little Endian).
4. Menulis ulang byte di alamat yang ditemukan untuk mengubah nilai dalam game.

**Catatan**: Karena ini pure Java, performa pencarian mungkin lebih lambat dibanding JNI, namun sangat efektif untuk game yang menyimpan data di Java Heap.
