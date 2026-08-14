# shellcheck disable=SC2148

# =============================== PROMPT INFO AND COLORS =======================================

if [ -n "${ZSH_VERSION:-}" ]; then
    # Zsh configuration
    # Zsh uses %{%} for non-printing escape sequences
    _PS1_NON_PRINTING_START="%{"
    _PS1_NON_PRINTING_END="%}"

    # Zsh prompt formatting variables
    _PS1_DATE_START="%D"
    PS1_HOSTNAME="%m"
    PS1_USERNAME="%n"
    PS1_CHAR_ROOT_or_UNPRIVILEGE="%(!.#.$)"

    # %~: current directory, with home directory replaced by ~
    # %1~: trailing component of the current working directory
    _DIR_ESCAPE="%~"
    _DIR_NAME_ESCAPE="%1~"
    
    # We use $'\n' to ensure compatibility with newlines in Zsh variables
    _NEWLINE=$'\n'

elif [ -n "${BASH_VERSION:-}" ]; then
    # Bash configuration
    # See prompt variables here: https://ss64.com/bash/syntax-prompt.html
    _PS1_NON_PRINTING_START="\["
    _PS1_NON_PRINTING_END="\]"

    _PS1_DATE_START="\D"
    PS1_HOSTNAME="\h"
    PS1_USERNAME="\u"
    PS1_CHAR_ROOT_or_UNPRIVILEGE='\$'

    _DIR_ESCAPE="\w"
    _DIR_NAME_ESCAPE="\W"
    _NEWLINE="\n"
fi

# Only configure and export PS1 if the shell is recognized
if [ -n "${_PS1_NON_PRINTING_START:-}" ]; then
    _PS1_COLOR_START=$'\033['
    _BOLD_YELLOW="1;93m"
    _BOLD_GREEN="1;32m"
    _BOLD_BLUE="1;34m"
    _COLOR_RESET="00m"

    PS1_DATE="${_PS1_DATE_START}{%Y-%m-%d}"
    PS1_TIME="${_PS1_DATE_START}{%H:%M:%S}"

    PS1_BOLD_YELLOW="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_BOLD_YELLOW}${_PS1_NON_PRINTING_END}"
    PS1_BOLD_GREEN="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_BOLD_GREEN}${_PS1_NON_PRINTING_END}"
    PS1_BOLD_BLUE="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_BOLD_BLUE}${_PS1_NON_PRINTING_END}"
    PS1_COLOR_RESET="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_COLOR_RESET}${_PS1_NON_PRINTING_END}"

    _CURRENT_DIR_FULL_PATH="${_NEWLINE}${PS1_BOLD_BLUE}${_DIR_ESCAPE}${PS1_COLOR_RESET}${_NEWLINE}"
    _CURRENT_DIR_NAME="${PS1_BOLD_BLUE}${_DIR_NAME_ESCAPE}${PS1_COLOR_RESET}"

    export PS1="${_CURRENT_DIR_FULL_PATH}${PS1_BOLD_YELLOW}${PS1_DATE}_${PS1_TIME} ${PS1_BOLD_GREEN}${PS1_USERNAME}@${PS1_HOSTNAME}:${_CURRENT_DIR_NAME}:${PS1_CHAR_ROOT_or_UNPRIVILEGE} "
fi
