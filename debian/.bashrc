#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Enable programmable completion features (if not already enabled system-wide)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ---------- Modern Bash Prompt ----------

parse_git_branch() {
    git branch --show-current 2>/dev/null
}

__prompt_command() {
    local EXIT="$?"

    if [ "$EXIT" -eq 0 ]; then
        SYMBOL="\[\e[1;32m\]❯"
    else
        SYMBOL="\[\e[1;31m\]❯"
    fi

    local GIT_BRANCH=$(parse_git_branch)

    if [ -n "$GIT_BRANCH" ]; then
        GIT_LINE="\n\[\e[38;5;214m\]├─ $GIT_BRANCH"
    else
        GIT_LINE=""
    fi

    PS1="\[\e[38;5;81m\]╭─ 󰣚 \u@\h \[\e[38;5;39m\]󰉋 \w${GIT_LINE}\n${SYMBOL}\[\e[0m\] "
}

PROMPT_COMMAND=__prompt_command
