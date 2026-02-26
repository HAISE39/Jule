#!/bin/bash

# Color codes for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Ask for the directory to upload
read -p "Enter the folder path you want to upload (default: current directory): " FOLDER
FOLDER=${FOLDER:-.}

if [ ! -d "$FOLDER" ]; then
    error_exit "Directory $FOLDER does not exist."
fi

cd "$FOLDER" || error_exit "Could not enter directory $FOLDER."

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Initializing new git repository...${NC}"
    git init || error_exit "Git init failed."
fi

# Set user config if not set
if [ -z "$(git config user.name)" ]; then
    read -p "Enter your GitHub username: " GH_USER
    git config --global user.name "$GH_USER"
fi

if [ -z "$(git config user.email)" ]; then
    read -p "Enter your GitHub email: " GH_EMAIL
    git config --global user.email "$GH_EMAIL"
fi

# Add all files
echo -e "${YELLOW}Adding files...${NC}"
git add .

# Commit changes
read -p "Enter commit message (default: 'Upload via Termux'): " MESSAGE
MESSAGE=${MESSAGE:-"Upload via Termux"}
git commit -m "$MESSAGE"

# Check for remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [ -z "$REMOTE_URL" ]; then
    echo -e "${YELLOW}No remote origin found.${NC}"
    read -p "Enter GitHub Repository URL (e.g., https://github.com/user/repo.git): " REPO_URL
    if [ -n "$REPO_URL" ]; then
        git remote add origin "$REPO_URL" || error_exit "Failed to add remote origin."
    else
        error_exit "Repository URL is required."
    fi
fi

# Branch handling
BRANCH=$(git branch --show-current)
if [ -z "$BRANCH" ]; then
    BRANCH="main"
    git branch -M "$BRANCH"
fi

echo -e "${YELLOW}Pushing to GitHub (branch: $BRANCH)...${NC}"
echo -e "${BLUE}Note: Use your Personal Access Token (PAT) as the password.${NC}"
git push -u origin "$BRANCH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully uploaded to GitHub!${NC}"
else
    echo -e "${RED}Upload failed. Check your connection, Repository URL, or Personal Access Token.${NC}"
fi
