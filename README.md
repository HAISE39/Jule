# Jule - GitHub Upload for Termux

Script sederhana untuk mengupload folder langsung ke GitHub melalui Termux. Karena GitHub tidak memiliki fitur unzip untuk folder yang diupload manual lewat web, script ini membantu Anda mengontrol repositori GitHub langsung dari Termux.

## Cara Penggunaan

1. **Unduh Script**
   Simpan script `git-upload.sh` di folder home Termux Anda.

2. **Berikan Izin Eksekusi**
   ```bash
   chmod +x git-upload.sh
   ```

3. **Jalankan Script**
   ```bash
   ./git-upload.sh
   ```

## Penjelasan "Path Folder"
Saat script meminta "Masukkan path folder", Anda memberikan alamat lokasi folder tersebut:
- **`.` (titik)**: Folder tempat Anda berada sekarang.
- **`Documents/web-saya`**: Folder bernama `web-saya` di dalam folder `Documents`.
- **`/sdcard/Download/folder-bot`**: Folder yang ada di folder Download memori internal HP Anda. (Pastikan sudah menjalankan `termux-setup-storage` untuk akses sdcard).
- **`~/scripts`**: Folder `scripts` di folder home Termux Anda.

## Persyaratan
- Termux
- Koneksi Internet
- Akun GitHub & Personal Access Token (PAT)
- Akses penyimpanan (Jalankan `termux-setup-storage` di Termux jika ingin upload dari folder HP).

## Tips
Saat diminta password oleh GitHub, **jangan masukkan password akun**, tetapi masukkan **Personal Access Token (PAT)** yang bisa dibuat di Settings > Developer Settings > Personal Access Tokens di GitHub.
