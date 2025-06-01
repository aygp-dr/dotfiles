# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Plugins (add useful ones for AI research)
plugins=(
  git
  python
  pip
  virtualenv
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  command-not-found
  dirhistory
  fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='emacs'
else
  export EDITOR='emacs'
fi

# Custom aliases for AI research
alias gpt="cd ~/projects/gpt"
alias jn="jupyter notebook"
alias jnl="jupyter lab"
alias tf="cd ~/projects/tensorflow"
alias pt="cd ~/projects/pytorch"
alias dstart="docker start"
alias dstop="docker stop"
alias dps="docker ps"
alias dpsa="docker ps -a"

# Python virtual environment helpers
alias pyv="python -m venv venv"
alias activate="source venv/bin/activate"

# Quick directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Copy
pbcopy() {
    xclip -selection clipboard
}

pbpaste() {
    xclip -selection clipboard -o
}

# File copy utility similar to pbcopy syntax
pbcopyfile() {
    if [ $# -ne 1 ]; then
        echo "Usage: pbcopyfile <filename>"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' not found"
        return 1
    fi
    
    cat "$1" | xclip -selection clipboard
    echo "Contents of '$1' copied to clipboard"
}

# Add custom paths for AI tools
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# CUDA paths if applicable
if [ -d "/usr/local/cuda/bin" ]; then
  export PATH="/usr/local/cuda/bin:$PATH"
  export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
fi

# Python path setup
export PYTHONPATH="$HOME/projects:$PYTHONPATH"

# Global NPM
export PATH=$PATH:~/.npm-global/bin

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Install additional plugins if not already installed
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=$PATH:~/.npm-global/bin
