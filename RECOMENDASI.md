# Rekomendasi Modul GameGuardian (Platform ELGG)

Berikut adalah daftar modul dan library yang direkomendasikan untuk pengembangan script mod menu di GameGuardian, khususnya menggunakan platform ELGG.

## 1. Library Antarmuka Pengguna (UI)

### **Changning E03PRO / Material3**
Library UI paling populer untuk ELGG saat ini. Mendukung tampilan modern bergaya Material Design 3.
- **Kelebihan**: Tampilan profesional, sidebar navigasi otomatis, komponen lengkap (button, switch, slider).
- **Penggunaan**: `loadYunLuaGroup("hash_library")` lalu gunakan API `CA`.

### **ImGui**
Library standar industri untuk overlay grafis.
- **Kelebihan**: Sangat cepat (Hardware Accelerated), responsif, dan fleksibel.
- **Penggunaan**: Cocok untuk menu yang membutuhkan banyak grafik atau pengaturan mendalam.

### **AlGui / VellMod**
Library UI alternatif yang lebih ringan.
- **Kelebihan**: Mudah dipelajari, cocok untuk script sederhana.

## 2. Modul Utilitas (Utility)

### **Memory API (`memory.lua`)**
Modul untuk manipulasi memori tanpa root melalui `/proc/self/mem`.
- **Fitur**: Pencarian pattern hex, pembacaan/penulisan DWORD, FLOAT, dan QWORD secara efisien menggunakan `java.io.RandomAccessFile`.

### **File Utility**
Modul bawaan ELGG untuk manajemen resource.
- **Fitur**: `file.download` untuk mengambil aset ikon dari URL, `file.mkdir` untuk membuat folder penyimpanan data mod.

## 3. Sistem Keamanan & Distribusi

### **Cloud Loader**
Metode pemuatan script secara dinamis dari server.
- **Fungsi**: Memudahkan update script tanpa mewajibkan user mendownload ulang, serta menambah lapisan keamanan (obfuscasi di sisi server).

### **Login Dialog**
Modul untuk sistem otentikasi.
- **Fungsi**: Membatasi akses script hanya untuk pengguna yang memiliki lisensi atau password.
