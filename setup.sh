#!/bin/bash

set -euo pipefail

# Base URL to your raw GitHub repository files
REPO_RAW_URL="https://raw.githubusercontent.com/caleonardo/bash_settings/refs/heads/main"


# Create a temporary directory for downloaded modules
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

# 1. Download helper scripts and configs
curl -fsSL "${REPO_RAW_URL}/_1_terminal_colors.sh" -o "${WORKDIR}/_1_terminal_colors.sh"
curl -fsSL "${REPO_RAW_URL}/_3_eternal_history.sh" -o "${WORKDIR}/_3_eternal_history.sh"
curl -fsSL "${REPO_RAW_URL}/.inputrc" -o "${WORKDIR}/.inputrc"

# 2. Create Local dir and copy files
mkdir ~/.bash_profile__custom_config_files
cp "${WORKDIR}/_1_terminal_colors.sh" ~/.bash_profile__custom_config_files/_1_terminal_colors.sh
cp "${WORKDIR}/_3_eternal_history.sh" ~/.bash_profile__custom_config_files/_3_eternal_history.sh
cat "${WORKDIR}/.inputrc" >> ~/.inputrc

# 3. Updating user ~/.profile
{
    echo  "# "
    "# Configure Terminal colors"
    "source ~/.bash_profile__custom_config_files/_1_terminal_colors.sh"
    "source ~/.bash_profile__custom_config_files/_3_eternal_history.sh"
} >> ~/.profile

# shellcheck disable=SC1090
source ~/.profile

# 4. Updating user ~/.inputrc
bind -d ~/.inputrc


echo "Main setup completed successfully."
