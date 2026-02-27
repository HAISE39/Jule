# Jule - GitHub Upload for Termux

Script sederhana untuk mengupload folder langsung ke GitHub melalui Termux. Script ini membantu Anda mengontrol repositori GitHub secara fleksibel, mendukung banyak repo, dan memudahkan pengaturan awal.

## Fitur Unggulan
- **Sinkronisasi Otomatis**: Menangani error `[rejected]` dengan melakukan sinkronisasi (`pull --rebase`) sebelum upload.
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
- **`~/project-saya`**: Folder di direktori home Termux.
- **`/sdcard/Download/script-bot`**: Folder di memori internal HP.

## Tips Penting
- **Error [Rejected]**: Jika muncul error ini, script akan otomatis mencoba menyamakan file Anda dengan yang ada di GitHub. Jika masih gagal, script akan menawarkan opsi **Force Push** (Gunakan dengan hati-hati!).
- **Personal Access Token (PAT)**: Gunakan Token GitHub sebagai password saat diminta.
- **Akses Storage**: Jalankan `termux-setup-storage` agar Termux bisa membaca folder di HP Anda.

## Persyaratan
- Termux & Internet.
- Akun GitHub.
