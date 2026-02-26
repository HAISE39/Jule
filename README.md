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

4. **Ikuti Instruksi**
   - Masukkan path folder yang ingin diupload (tekan Enter untuk folder saat ini).
   - Masukkan username dan email GitHub jika belum dikonfigurasi.
   - Masukkan pesan commit.
   - Masukkan URL Repositori GitHub jika belum ada remote.
   - Saat diminta password, **gunakan Personal Access Token (PAT)** GitHub Anda, bukan password akun.

## Persyaratan
- Termux
- Koneksi Internet
- Akun GitHub & Personal Access Token (PAT)
