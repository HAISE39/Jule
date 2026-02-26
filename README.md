# Jule - GitHub Upload for Termux

Script sederhana untuk mengupload folder langsung ke GitHub melalui Termux. Script ini membantu Anda mengontrol repositori GitHub secara fleksibel, mendukung banyak repo, dan memudahkan pengaturan awal.

## Fitur Baru
- **Tautan Akun Otomatis**: Script akan meminta username & email jika belum pernah diatur.
- **Dukungan Banyak Repo**: Anda bisa mengganti link repository GitHub kapan saja saat menjalankan script.
- **Penanganan Path Cerdas**: Mendukung penggunaan `~` (home) secara langsung.

## Cara Penggunaan

1. **Persiapan**
   Simpan script `git-upload.sh` di folder home Termux Anda.

2. **Izin Eksekusi**
   ```bash
   chmod +x git-upload.sh
   ```

3. **Jalankan Script**
   ```bash
   ./git-upload.sh
   ```

## Penjelasan "Path Folder"
Saat script meminta path folder, Anda bisa memasukkan:
- **`.` (titik)**: Untuk folder saat ini.
- **`~/kim/app`**: Contoh folder di direktori home Anda.
- **`/sdcard/Download/project`**: Contoh folder di penyimpanan internal HP.

## Tips Penting
- **Personal Access Token (PAT)**: Saat GitHub meminta password, masukkan **Token**, bukan password akun Anda.
- **Akses Storage**: Jika ingin upload dari memori HP, pastikan sudah menjalankan `termux-setup-storage`.

## Persyaratan
- Termux & Internet.
- Akun GitHub.
