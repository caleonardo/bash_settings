#!/bin/bash

echo "Configures Bash Colors, commands lookup and eternal history."

set -euo pipefail

# Base URL to your raw GitHub repository files
REPO_RAW_URL="https://raw.githubusercontent.com/caleonardo/bash_settings/refs/heads/main"


echo "Creating a temporary directory for downloaded modules"
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

echo "1. Download helper scripts and configs"
curl -fsSL "${REPO_RAW_URL}/_1_terminal_colors.sh" -o "${WORKDIR}/_1_terminal_colors.sh"
curl -fsSL "${REPO_RAW_URL}/_3_eternal_history.sh" -o "${WORKDIR}/_3_eternal_history.sh"
curl -fsSL "${REPO_RAW_URL}/.inputrc" -o "${WORKDIR}/.inputrc"

echo "2. Create Local dir and copy files in ~/.bash_profile__custom_config_files"
mkdir ~/.bash_profile__custom_config_files
cp "${WORKDIR}/_1_terminal_colors.sh" ~/.bash_profile__custom_config_files/_1_terminal_colors.sh
cp "${WORKDIR}/_3_eternal_history.sh" ~/.bash_profile__custom_config_files/_3_eternal_history.sh

echo "3. Updating user ~/.profile"
echo "# " >> ~/.profile
echo "# Configure Terminal colors" >> ~/.profile
echo "source ~/.bash_profile__custom_config_files/_1_terminal_colors.sh" >> ~/.profile
echo "source ~/.bash_profile__custom_config_files/_3_eternal_history.sh" >> ~/.profile

# shellcheck disable=SC1090
source ~/.profile

echo "4. Updating user ~/.inputrc"
cat "${WORKDIR}/.inputrc" >> ~/.inputrc
bind -f ~/.inputrc

echo "Setup completed successfully."
