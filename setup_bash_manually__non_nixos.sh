#!/bin/bash

echo "Configures Terminal Colors, command search keybindings, and eternal history."

set -euo pipefail

# Base URL to your raw GitHub repository files
REPO_RAW_URL="https://raw.githubusercontent.com/caleonardo/bash_settings/refs/heads/main"

# Determine the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Creating a temporary directory for downloaded modules..."
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

echo "1. Obtain helper scripts and configs"
if [ -f "${SCRIPT_DIR}/_1_terminal_colors.sh" ] && \
   [ -f "${SCRIPT_DIR}/_2_keybindings.sh" ] && \
   [ -f "${SCRIPT_DIR}/_3_eternal_history.sh" ] && \
   [ -f "${SCRIPT_DIR}/.inputrc" ]; then
    echo "  Found local configuration files. Copying..."
    cp "${SCRIPT_DIR}/_1_terminal_colors.sh" "${WORKDIR}/_1_terminal_colors.sh"
    cp "${SCRIPT_DIR}/_2_keybindings.sh" "${WORKDIR}/_2_keybindings.sh"
    cp "${SCRIPT_DIR}/_3_eternal_history.sh" "${WORKDIR}/_3_eternal_history.sh"
    cp "${SCRIPT_DIR}/.inputrc" "${WORKDIR}/.inputrc"
else
    echo "  Downloading configuration files from remote repository..."
    curl -fsSL "${REPO_RAW_URL}/_1_terminal_colors.sh" -o "${WORKDIR}/_1_terminal_colors.sh"
    curl -fsSL "${REPO_RAW_URL}/_2_keybindings.sh" -o "${WORKDIR}/_2_keybindings.sh"
    curl -fsSL "${REPO_RAW_URL}/_3_eternal_history.sh" -o "${WORKDIR}/_3_eternal_history.sh"
    curl -fsSL "${REPO_RAW_URL}/.inputrc" -o "${WORKDIR}/.inputrc"
fi

echo "2. Create Local dir and copy files to ~/.bash_profile__custom_config_files"
mkdir -p "$HOME/.bash_profile__custom_config_files"
cp "${WORKDIR}/_1_terminal_colors.sh" "$HOME/.bash_profile__custom_config_files/_1_terminal_colors.sh"
cp "${WORKDIR}/_2_keybindings.sh" "$HOME/.bash_profile__custom_config_files/_2_keybindings.sh"
cp "${WORKDIR}/_3_eternal_history.sh" "$HOME/.bash_profile__custom_config_files/_3_eternal_history.sh"

echo "3. Updating user shell profile configurations"

# Helper function to append configuration idempotently
append_to_file_if_missing() {
    local target_file="$1"
    local search_string="$2"
    local content_to_append="$3"
    
    # Ensure the file exists
    touch "$target_file"
    
    if grep -Fq "$search_string" "$target_file"; then
        echo "  Configuration already present in $target_file. Skipping."
    else
        echo "  Updating $target_file..."
        printf "\n%s\n" "$content_to_append" >> "$target_file"
    fi
}

# Define the block of code to source colors, keybindings, and history
SOURCE_BLOCK=$(cat << 'EOF'
# Configure Terminal colors & eternal history
if [ -f ~/.bash_profile__custom_config_files/_1_terminal_colors.sh ]; then
    source ~/.bash_profile__custom_config_files/_1_terminal_colors.sh
fi
if [ -f ~/.bash_profile__custom_config_files/_2_keybindings.sh ]; then
    source ~/.bash_profile__custom_config_files/_2_keybindings.sh
fi
if [ -f ~/.bash_profile__custom_config_files/_3_eternal_history.sh ]; then
    source ~/.bash_profile__custom_config_files/_3_eternal_history.sh
fi
EOF
)

# Configure Bash
OS_TYPE="$(uname -s)"
if [[ "$OS_TYPE" == "Darwin" ]]; then
    echo "macOS Bash uses ~/.bash_profile"
    append_to_file_if_missing "$HOME/.bash_profile" "_1_terminal_colors.sh" "$SOURCE_BLOCK"
elif [[ "$OS_TYPE" == "Linux" ]]; then
    echo "Linux Bash uses ~/.bashrc"
    append_to_file_if_missing "$HOME/.bashrc" "_1_terminal_colors.sh" "$SOURCE_BLOCK"
else
    echo "Unrecognized OS ($OS_TYPE). Defaulting to updating ~/.bashrc..."
    append_to_file_if_missing "$HOME/.bashrc" "_1_terminal_colors.sh" "$SOURCE_BLOCK"
fi

# Configure Zsh (default on macOS since Catalina)
if command -v zsh >/dev/null 2>&1 || [ -x /bin/zsh ]; then
    append_to_file_if_missing "$HOME/.zshrc" "_1_terminal_colors.sh" "$SOURCE_BLOCK"
fi

echo "4. Updating user ~/.inputrc (for Bash readline)"
INPUTRC_BLOCK=$(cat << 'EOF'
# using "arrow up" and "arrow down" to search the history
"\e[A": history-search-backward
"\e[B": history-search-forward
EOF
)
append_to_file_if_missing "$HOME/.inputrc" "history-search-backward" "$INPUTRC_BLOCK"

echo ""
echo "Setup completed successfully."
echo "Either restart your terminal session or run the following to apply changes:"
if command -v zsh >/dev/null 2>&1 || [ -x /bin/zsh ]; then
    echo "  For Zsh:  source ~/.zshrc"
fi
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "  For Bash: source ~/.bash_profile"
else
    echo "  For Bash: source ~/.bashrc"
fi
