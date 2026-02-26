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
    echo -e "${YELLOW}Git is not installed. Installing...${NC}"
    pkg install git -y || error_exit "Failed to install git."
fi

echo -e "${BLUE}=== GitHub Upload Script for Termux ===${NC}"
echo -e "${CYAN}Contoh path folder:${NC}"
echo -e "  ${YELLOW}.${NC}              (folder saat ini)"
echo -e "  ${YELLOW}Documents/project${NC} (folder di dalam Documents)"
echo -e "  ${YELLOW}/sdcard/Download/folder-anda${NC} (folder di Download HP)"
echo ""

# Ask for the directory to upload
read -p "Masukkan path folder yang ingin diupload: " FOLDER
FOLDER=${FOLDER:-.}

# Expand ~ to home directory if present
FOLDER="${FOLDER/#\~/$HOME}"

if [ ! -d "$FOLDER" ]; then
    error_exit "Directory $FOLDER tidak ditemukan."
fi

cd "$FOLDER" || error_exit "Tidak bisa masuk ke direktori $FOLDER."

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Initializing new git repository...${NC}"
    git init || error_exit "Git init failed."
fi

# Set user config if not set
if [ -z "$(git config user.name)" ]; then
    read -p "Masukkan GitHub username Anda: " GH_USER
    git config --global user.name "$GH_USER"
fi

if [ -z "$(git config user.email)" ]; then
    read -p "Masukkan GitHub email Anda: " GH_EMAIL
    git config --global user.email "$GH_EMAIL"
fi

# Add all files
echo -e "${YELLOW}Menambahkan file...${NC}"
git add .

# Commit changes
read -p "Masukkan pesan commit (default: 'Upload via Termux'): " MESSAGE
MESSAGE=${MESSAGE:-"Upload via Termux"}
git commit -m "$MESSAGE"

# Check for remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [ -z "$REMOTE_URL" ]; then
    echo -e "${YELLOW}Remote origin belum diset.${NC}"
    read -p "Masukkan URL Repositori GitHub: " REPO_URL
    if [ -n "$REPO_URL" ]; then
        git remote add origin "$REPO_URL" || error_exit "Gagal menambahkan remote origin."
    else
        error_exit "URL Repositori wajib diisi."
    fi
fi

# Branch handling
BRANCH=$(git branch --show-current)
if [ -z "$BRANCH" ]; then
    BRANCH="main"
    git branch -M "$BRANCH"
fi

echo -e "${YELLOW}Pushing ke GitHub (branch: $BRANCH)...${NC}"
echo -e "${BLUE}Catatan: Gunakan Personal Access Token (PAT) sebagai password.${NC}"
git push -u origin "$BRANCH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Berhasil diupload ke GitHub!${NC}"
else
    echo -e "${RED}Upload gagal. Cek koneksi, URL Repo, atau Personal Access Token Anda.${NC}"
fi
