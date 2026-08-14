# shellcheck disable=SC2148

# ============================= ETERNAL HISTORY =====================================

if [ -n "${ZSH_VERSION:-}" ]; then
    # Zsh Eternal History Settings
    # Large numbers are standard in Zsh for virtual "unlimited" history
    export HISTSIZE=10000000
    export SAVEHIST=10000000

    # Extended history records timestamp and command duration
    setopt EXTENDED_HISTORY
    # Append to history file instead of overwriting
    setopt APPEND_HISTORY
    # Write to history file immediately after command execution
    setopt INC_APPEND_HISTORY
    # Share history immediately across all active sessions
    setopt SHARE_HISTORY

elif [ -n "${BASH_VERSION:-}" ]; then
    # Bash Eternal History Settings

    # Set size to "unlimited"
    export HISTFILESIZE=-1
    export HISTSIZE=-1
    export HISTTIMEFORMAT="[%F %T] "
    # Change the file location because certain bash sessions truncate .bash_history file upon close.
    # http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
    # export HISTFILE=/data/tech_labs/settings/linux/nixos/settings_nixos/users/_common/dotfiles/.bash_eternal_history
    # Force prompt to write history after every command.
    # Documented in https://unix.stackexchange.com/questions/767621/i-cant-get-bash-history-to-update-instantly-in-all-terminals
    # original_prompt_command=${original_prompt_command-$PROMPT_COMMAND}
    # PROMPT_COMMAND="history -a; history -n; $original_prompt_command"

    # Append to history file
    shopt -s histappend

    # Safely initialize original_prompt_command only if PROMPT_COMMAND is set and it hasn't been defined yet
    if [ -z "${original+x}" ]; then
        original_prompt_command="${PROMPT_COMMAND:-}"
        readonly original=1
    fi

    # Force prompt to write history after every command and read new history.
    PROMPT_COMMAND="history -a; history -n; ${original_prompt_command}"
fi
