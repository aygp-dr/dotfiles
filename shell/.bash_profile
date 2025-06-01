# ~/.bash_profile - executed for interactive login shells

# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Environment variables
export GPG_TTY=$(tty)
export EDITOR=emacs
export PAGER="less -R"
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export BAT_THEME="Monokai Extended"
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' 2>/dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*' 2>/dev/null"
export MANPAGER="sh -c 'col -bx | less'"

# Path enhancements (avoid duplicating what's in .bashrc)
[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && export PATH=$HOME/.local/bin:$PATH

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
