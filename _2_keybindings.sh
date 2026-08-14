# shellcheck disable=SC2148

# ============================= KEYBINDINGS =====================================

if [ -n "${ZSH_VERSION:-}" ]; then
    # Zsh history search keybindings (equivalent to .inputrc history-search-backward / history-search-forward)
    # Allows typing prefix and using Up/Down arrow keys to search history matching prefix
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey '^[[A' up-line-or-beginning-search
    bindkey '^[OA' up-line-or-beginning-search
    bindkey '^[[B' down-line-or-beginning-search
    bindkey '^[OB' down-line-or-beginning-search
fi
