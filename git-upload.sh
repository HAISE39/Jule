#!/bin/bash

# Color codes for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display error and exit
error_exit() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git tidak ditemukan. Menginstall...${NC}"
    pkg install git -y || error_exit "Gagal menginstall git."
fi

echo -e "${BLUE}=== GitHub Upload Script for Termux ===${NC}"

# Setup account if not configured
if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
    echo -e "${CYAN}Menyiapkan identitas GitHub (Hanya sekali)...${NC}"
    read -p "Masukkan GitHub Username: " GH_USER
    read -p "Masukkan GitHub Email: " GH_EMAIL
    git config --global user.name "$GH_USER"
    git config --global user.email "$GH_EMAIL"
    echo -e "${GREEN}Identitas berhasil disimpan!${NC}"
fi

echo -e "${CYAN}Contoh path folder:${NC}"
echo -e "  ${YELLOW}.${NC}              (folder saat ini)"
echo -e "  ${YELLOW}Documents/project${NC} (folder di dalam Documents)"
echo -e "  ${YELLOW}/sdcard/Download/folder-anda${NC} (folder di Download HP)"
echo ""

# Ask for the directory to upload
read -p "Masukkan path folder yang ingin diupload: " FOLDER_INPUT
FOLDER_INPUT=${FOLDER_INPUT:-.}

# Manual expansion of ~ (Tilde) because 'read' does not expand it
if [[ "$FOLDER_INPUT" == "~/"* ]]; then
    FOLDER="${HOME}/${FOLDER_INPUT:2}"
elif [[ "$FOLDER_INPUT" == "~" ]]; then
    FOLDER="${HOME}"
else
    FOLDER="$FOLDER_INPUT"
fi

if [ ! -d "$FOLDER" ]; then
    error_exit "Folder '$FOLDER' tidak ditemukan. Pastikan alamatnya benar."
fi

cd "$FOLDER" || error_exit "Tidak bisa masuk ke direktori $FOLDER."

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Membuat repositori git baru di folder ini...${NC}"
    git init || error_exit "Gagal inisialisasi git."
fi

# Remote handling
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [ -n "$REMOTE_URL" ]; then
    echo -e "${CYAN}Remote saat ini:${NC} $REMOTE_URL"
    read -p "Ingin menggunakan link repo lain? (y/n, default: n): " CHANGE_REMOTE
    if [[ "$CHANGE_REMOTE" =~ ^[Yy]$ ]]; then
        git remote remove origin
        REMOTE_URL=""
    fi
fi

if [ -z "$REMOTE_URL" ]; then
    read -p "Masukkan Link Repository GitHub (https://github.com/user/repo.git): " REPO_URL
    if [ -n "$REPO_URL" ]; then
        git remote add origin "$REPO_URL" || error_exit "Gagal menambahkan link repo."
    else
        error_exit "Link repository wajib diisi."
    fi
fi

# Add and Commit
echo -e "${YELLOW}Menyiapkan file...${NC}"
git add .
read -p "Pesan Update (Commit): " MESSAGE
MESSAGE=${MESSAGE:-"Update via Termux"}
git commit -m "$MESSAGE"

# Branch handling
BRANCH=$(git branch --show-current)
BRANCH=${BRANCH:-main}
git branch -M "$BRANCH"

echo -e "${YELLOW}Pushing ke GitHub...${NC}"
echo -e "${BLUE}Catatan: Gunakan Personal Access Token (PAT) sebagai pengganti password.${NC}"
git push -u origin "$BRANCH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}BERHASIL! Folder telah diupload ke GitHub.${NC}"
else
    echo -e "${RED}GAGAL! Periksa koneksi atau token GitHub Anda.${NC}"
fi
