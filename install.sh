#!/bin/sh
# Dotfiles installation script for Emacs/Lisp-focused environment on FreeBSD
# Compatible with existing ~/.anthropic from dotanthropic

set -e

DOTFILES_DIR="$(cd "$(dirname "${0}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles.bak.$(date +%Y%m%d%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup and link a file
backup_and_link() {
    local src="$1"
    local dest="$2"
    
    # Backup existing file if it exists and is not a symlink
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "${YELLOW}Backing up${NC} $dest to $BACKUP_DIR"
        cp -R "$dest" "$BACKUP_DIR/" || true
    fi
    
    # Remove existing file/symlink
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        rm -rf "$dest"
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    # Create symlink
    echo "${GREEN}Linking${NC} $src to $dest"
    ln -sf "$src" "$dest"
}

echo "${BLUE}Installing dotfiles...${NC}"

# Check for required packages on FreeBSD
if [ "$(uname)" = "FreeBSD" ]; then
    echo "${BLUE}Checking for required FreeBSD packages...${NC}"
    
    # Required packages
    required_packages="emacs git"
    
    # Recommended packages
    recommended_packages="verbiste sbcl rlwrap"
    
    # Check required packages
    missing_required=""
    for pkg in $required_packages; do
        if ! pkg info -e "$pkg" > /dev/null 2>&1; then
            missing_required="$missing_required $pkg"
        fi
    done
    
    # Check recommended packages
    missing_recommended=""
    for pkg in $recommended_packages; do
        if ! pkg info -e "$pkg" > /dev/null 2>&1; then
            missing_recommended="$missing_recommended $pkg"
        fi
    done
    
    # Prompt to install if missing
    if [ -n "$missing_required" ]; then
        echo "${YELLOW}Required packages missing:${NC}$missing_required"
        echo "Please install them with: sudo pkg install$missing_required"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "${RED}Installation cancelled.${NC}"
            exit 1
        fi
    fi
    
    if [ -n "$missing_recommended" ]; then
        echo "${YELLOW}Recommended packages missing:${NC}$missing_recommended"
        echo "You may want to install them with: sudo pkg install$missing_recommended"
    fi
fi

# Shell files
echo "${BLUE}Setting up shell configuration...${NC}"
backup_and_link "$DOTFILES_DIR/shell/.bash_profile" "$HOME/.bash_profile"
backup_and_link "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"
backup_and_link "$DOTFILES_DIR/shell/.profile" "$HOME/.profile"
backup_and_link "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"

# Tmux
echo "${BLUE}Setting up tmux configuration...${NC}"
backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Emacs setup (primary focus)
echo "${BLUE}Setting up Emacs configuration...${NC}"
if [ ! -d "$HOME/.emacs.d" ]; then
    mkdir -p "$HOME/.emacs.d"
fi

# Link Emacs configuration
backup_and_link "$DOTFILES_DIR/editors/emacs/init.el" "$HOME/.emacs.d/init.el"
mkdir -p "$HOME/.emacs.d/lisp"
for f in "$DOTFILES_DIR"/editors/emacs/lisp/*.el; do
    if [ -f "$f" ]; then
        filename=$(basename "$f")
        backup_and_link "$f" "$HOME/.emacs.d/lisp/$filename"
    fi
done

# Create custom.el if it doesn't exist
if [ ! -f "$HOME/.emacs.d/custom.el" ]; then
    touch "$HOME/.emacs.d/custom.el"
    echo "${GREEN}Created${NC} $HOME/.emacs.d/custom.el"
fi

# Check if .anthropic already exists (from dotanthropic)
if [ ! -d "$HOME/.anthropic" ]; then
    echo "${YELLOW}Warning:${NC} ~/.anthropic directory not found."
    echo "This dotfiles setup expects the ~/.anthropic directory from dotanthropic."
    echo "Creating a basic structure instead."
    mkdir -p "$HOME/.anthropic/journal"
    mkdir -p "$HOME/.anthropic/tools"
    mkdir -p "$HOME/.anthropic/sandbox"
    mkdir -p "$HOME/.anthropic/reports"
    mkdir -p "$HOME/.anthropic/logs"
else
    echo "${GREEN}Found${NC} existing ~/.anthropic directory. Using it."
fi

# Add global gitignore with sensitive patterns
if [ -f "$DOTFILES_DIR/git/.gitignore_global" ]; then
    backup_and_link "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    git config --global core.excludesfile ~/.gitignore_global
fi

# Create a symlink to the bin directory
if [ -d "$DOTFILES_DIR/bin" ]; then
    if [ ! -d "$HOME/bin" ]; then
        mkdir -p "$HOME/bin"
    fi
    
    for f in "$DOTFILES_DIR"/bin/*; do
        if [ -f "$f" ] && [ -x "$f" ]; then
            filename=$(basename "$f")
            backup_and_link "$f" "$HOME/bin/$filename"
        fi
    done
    
    # Make sure ~/bin is in PATH
    if ! echo "$PATH" | grep -q "$HOME/bin"; then
        echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$HOME/.bash_profile"
        echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$HOME/.zshrc"
    fi
fi

echo "${GREEN}Dotfiles installation completed!${NC}"
echo "${YELLOW}Backup of previous configuration saved in:${NC} $BACKUP_DIR"
echo "${BLUE}Run 'source ~/.bashrc' or restart your shell to apply changes${NC}"