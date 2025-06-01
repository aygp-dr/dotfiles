# ~/.profile - FreeBSD login shell configuration

# Path configuration
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.npm-global/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Environment variables
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c"
export PAGER="less -R"
export MANPAGER="sh -c 'col -bx | less'"
export GPG_TTY=$(tty)

# Tool-specific configurations
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export BAT_THEME="Monokai Extended"

# FZF configuration
export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' 2>/dev/null"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*' 2>/dev/null"

# FreeBSD traditionally doesn't source .bashrc from .profile
# This is handled by the shell itself
