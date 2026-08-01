# shellcheck disable=SC2148
# Make sure variables are declared before use
set -u

# =============================== PROMPT INFO AND COLORS =======================================
# export PS1="\[\e[1;93m\]\D{%Y-%m-%d} \t \h:\u \W \$ \[\e[0;92m\]"
# export PS1="\[\033[1;93m\]\D{%Y-%m-%d} \t \h:\u \W \$ \[\033[0;92m\]"
# export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;93m\]\D{%Y-%m-%d} \t \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$"

# See promt variables here: https://ss64.com/bash/syntax-prompt.html
PS1_DATE="\D{%Y-%m-%d}"
PS1_TIME="\t"

PS1_HOSTNAME="\h"
PS1_USERNAME="\u"

# PS1_BELL="\a"
# PS1_ESCAPE="\e"

# _PS1_NON_PRINTING_START="\[\033\e["
_PS1_NON_PRINTING_START="\["
_PS1_NON_PRINTING_END="\]"

_PS1_COLOR_START="\033["
_BOLD_YELLOW="1;93m" # or PS1_BOLD_YELLOW="\e[1;34m"
_BOLD_GREEN="1;32m" # or PS1_BOLD_GREEN="\e[1;32m"
_BOLD_BLUE="1;34m" # or PS1_BOLD_BLUE="\e[1;34m"
_COLOR_RESET="00m"

PS1_BOLD_YELLOW="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_BOLD_YELLOW}${_PS1_NON_PRINTING_END}"
PS1_BOLD_GREEN="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_BOLD_GREEN}${_PS1_NON_PRINTING_END}"
PS1_BOLD_BLUE="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_BOLD_BLUE}${_PS1_NON_PRINTING_END}"
PS1_COLOR_RESET="${_PS1_NON_PRINTING_START}${_PS1_COLOR_START}${_COLOR_RESET}${_PS1_NON_PRINTING_END}"

_CURRENT_DIR_FULL_PATH="\n${PS1_BOLD_BLUE}\w${PS1_COLOR_RESET}\n"
_CURRENT_DIR_NAME="${PS1_BOLD_BLUE}\W${PS1_COLOR_RESET}"

export PS1="${_CURRENT_DIR_FULL_PATH}${PS1_BOLD_YELLOW}${PS1_DATE}_${PS1_TIME} ${PS1_BOLD_GREEN}${PS1_USERNAME}@${PS1_HOSTNAME}:${_CURRENT_DIR_NAME}:\$ "
