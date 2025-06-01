# ~/.bashrc - FreeBSD bash-specific configuration for interactive shells

# History configuration
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Enable bash-specific completions
if ! shopt -oq posix; then
    if [ -f /usr/local/share/bash-completion/bash_completion ]; then
        . /usr/local/share/bash-completion/bash_completion
    elif [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    fi
fi

# Project-specific environment loader
load_project_env() {
    if [ -f .envrc ]; then
        direnv allow
    fi
}

# Automatically load project environment when entering a directory
cd() {
    builtin cd "$@"
    load_project_env
}

# Emacs aliases and functions
alias ec='emacsclient -t'
alias ecg='emacsclient -c'
alias em='emacs -nw'

# Start Emacs daemon if not running
start_emacs_daemon() {
    if ! pgrep -f "emacs --daemon" > /dev/null; then
        emacs --daemon
    fi
}

# Connect to running Emacs or start a new session
e() {
    if pgrep -f "emacs --daemon" > /dev/null; then
        emacsclient -t "$@"
    else
        emacs -nw "$@"
    fi
}

# Start Emacs daemon on login
start_emacs_daemon

# Edit function - opens file in Emacs at specified line
edit() {
    if [ "$#" -eq 2 ] && [[ "$2" =~ ^[0-9]+$ ]]; then
        emacsclient -t +$2 "$1"
    else
        emacsclient -t "$@"
    fi
}

# Lisp development
alias sbcl='rlwrap sbcl'
alias clisp='rlwrap clisp'
alias guile='rlwrap guile'
alias clj='rlwrap clojure'

# NexusHive specific aliases
alias nh='cd ~/projects/nexushive'
alias nhsetup='cd ~/projects/nexushive-setup'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# System aliases
alias ll='ls -laF'
alias df='df -h'
alias du='du -h'

# FreeBSD specific
alias portup='sudo pkg update && sudo pkg upgrade'
alias portls='pkg info'
alias ports='cd /usr/ports'

# Direnv setup
if command -v direnv &> /dev/null; then
    eval "$(direnv hook bash)"
fi

# Source fzf configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Source local customizations if they exist
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi

export PATH=$PATH:~/.npm-global/bin
export GPG_TTY=$(tty)

# AYGP agent configuration
export AYGP_HOME="$HOME/.anthropic"
export AYGP_JOURNAL="$AYGP_HOME/journal"

# Apply custom keyboard mapping when in TTY
if [ "$(tty)" = "/dev/ttyv1" ]; then
  sudo /home/jwalsh/projects/aygp-dr/nexushive-setup/scripts/setup-tty-keyboard.sh
fi

export PULSE_SERVER=pi.lan