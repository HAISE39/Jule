# Rekomendasi Modul & Fitur ELGG (Sumber Resmi)

Berdasarkan dokumentasi resmi dari [Gitee ELGG](https://gitee.com/xiaomanyun/elgg), berikut adalah rekomendasi fitur dan modul untuk pengembangan script mod menu yang profesional:

## 1. Antarmuka Pengguna (UI) & Grafis

### **Official Material3 Library**
Library UI utama yang terdapat langsung di repositori resmi.
- **Fitur**: Desain modern Material 3, komponen responsif, dan dukungan tema dinamis.
- **Rekomendasi**: Gunakan library ini untuk membuat menu sidebar yang elegan dan sesuai standar ELGG terbaru.

### **ImGui & DrawGG**
Dua library penting untuk interaksi visual langsung di atas game.
- **ImGui**: Digunakan untuk menu floating window yang kompleks dan berkinerja tinggi.
- **DrawGG**: Modul khusus untuk melakukan *drawing* atau penggambaran (seperti ESP/Line/Box) langsung pada layar game.

### **WebView (H5 UI)**
ELGG mendukung pemuatan antarmuka berbasis HTML5.
- **Kelebihan**: Anda bisa menggunakan keahlian web development (HTML/CSS/JS) untuk membuat UI yang sangat kustom dan cantik menggunakan `h5gg` UI.

## 2. Fitur Lanjutan (Advanced Features)

### **luajava**
Fitur paling powerful yang memungkinkan script Lua berinteraksi langsung dengan API Android.
- **Kegunaan**: Memanggil sistem service, memanipulasi View Android secara native, atau mengakses fitur perangkat yang tidak tersedia di Lua standar.

### **Loading External Files (.dex / .jar)**
Anda dapat memuat file Java eksternal untuk memperluas fungsionalitas script.
- **Kegunaan**: Menjalankan logika Java yang kompleks atau menggunakan library Java pihak ketiga di dalam script Lua Anda.

## 3. Keamanan & Proteksi (Built-in Security)

### **Lua-to-Dex Encryption**
Fitur unggulan ELGG untuk mengamankan kode sumber.
- **Fungsi**: Mengonversi script Lua menjadi bytecode Dex yang sangat sulit untuk didekompilasi oleh attacker.

### **Firewall & Anti-Log System**
ELGG memiliki mekanisme internal untuk mendeteksi dan mencegah upaya *hooking* atau *logging* terhadap fungsi-fungsi penting GG (seperti `gg.editAll`, `gg.setValues`).
- **Mekanisme**: Menggunakan saluran enkripsi antara layer Lua dan Java untuk mengirim data, serta menyuntikkan data sampah untuk mengelabui logger.

## 4. Utilitas Rekomendasi

### **ELGG Toolbox (ELGG工具箱.lua)**
Gunakan script toolbox resmi untuk mempermudah proses enkripsi, pengaturan project, dan distribusi update melalui cloud.

### **Cloud Integration**
Manfaatkan integrasi dengan **EL云验证** (Cloud Verification) untuk sistem login dan manajemen pengguna yang lebih aman dan terpusat.
