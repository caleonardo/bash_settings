# shellcheck disable=SC2148
# Make sure variables are declared before use
set -u
# ============================= ETERNAL BASH HISTORY =====================================
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
# export HISTFILE=/data/tech_labs/settings/linux/nixos/settings_nixos/users/_common/dotfiles/.bash_eternal_history
# Force prompt to write history after every command.
# Documented in https://unix.stackexchange.com/questions/767621/i-cant-get-bash-history-to-update-instantly-in-all-terminals
set +u
# original_prompt_command=${original_prompt_command-$PROMPT_COMMAND}
# PROMPT_COMMAND="history -a; history -n; $original_prompt_command"

shopt -s histappend

# Safely initialize original_prompt_command only if PROMPT_COMMAND is set and it hasn't been defined yet
if [ -z "${original+x}" ]; then
    original_prompt_command="${PROMPT_COMMAND:-}"
    readonly original=1
fi

PROMPT_COMMAND="history -a; history -n; ${original_prompt_command}"
