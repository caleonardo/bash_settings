# shellcheck disable=SC2148

# ============================= ETERNAL HISTORY =====================================

if [ -n "${ZSH_VERSION:-}" ]; then
    # Zsh Eternal History Settings
    export HISTFILE="${HOME}/.zsh_history"
    # Large numbers are standard in Zsh for virtual "unlimited" history
    export HISTSIZE=10000000
    export SAVEHIST=10000000

    # Extended history records timestamp and command duration
    setopt EXTENDED_HISTORY
    # Share history immediately across all active sessions (also handles append)
    setopt SHARE_HISTORY
    # Expire duplicate entries first when trimming history
    setopt HIST_EXPIRE_DUPS_FIRST
    # Don't record an entry that was just recorded
    setopt HIST_IGNORE_DUPS
    # Don't record an entry starting with a space
    setopt HIST_IGNORE_SPACE
    # Don't execute immediately upon history expansion
    setopt HIST_VERIFY

elif [ -n "${BASH_VERSION:-}" ]; then
    # Bash Eternal History Settings
    export HISTFILE="${HOME}/.bash_history"
    
    # Set size to "unlimited"
    # Note: macOS ships with Bash 3.2 where negative values (-1) are unsupported and clear the history buffer!
    # Large numbers provide virtually unlimited history and are compatible across all Bash versions (3.2 through 5.x).
    export HISTSIZE=10000000
    export HISTFILESIZE=10000000
    export HISTTIMEFORMAT="[%F %T] "

    # Change the file location because certain bash sessions truncate .bash_history file upon close.
    # http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
    # export HISTFILE=/data/tech_labs/settings/linux/nixos/settings_nixos/users/_common/dotfiles/.bash_eternal_history
    # Force prompt to write history after every command.
    # Documented in https://unix.stackexchange.com/questions/767621/i-cant-get-bash-history-to-update-instantly-in-all-terminals
    # original_prompt_command=${original_prompt_command-$PROMPT_COMMAND}
    # PROMPT_COMMAND="history -a; history -n; $original_prompt_command"

    # Append to history file instead of overwriting
    shopt -s histappend

    # Safely initialize original_prompt_command only if PROMPT_COMMAND is set and it hasn't been defined yet
    if [ -z "${original+x}" ]; then
        original_prompt_command="${PROMPT_COMMAND:-}"
        readonly original=1
    fi

    # Force prompt to write history after every command and read new history.
    PROMPT_COMMAND="history -a; history -n; ${original_prompt_command}"
fi
