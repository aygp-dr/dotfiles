#!/bin/sh
# Script to test dotfiles configuration on FreeBSD

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${0}")/.." && pwd)"

echo "${BLUE}Testing dotfiles configuration...${NC}"

# Test operating system compatibility
echo "${YELLOW}Testing operating system compatibility...${NC}"
if uname -a | grep -q "FreeBSD"; then
    echo "${GREEN}Running on FreeBSD - full compatibility.${NC}"
elif uname -a | grep -q "Linux"; then
    echo "${YELLOW}Running on Linux - partial compatibility.${NC}"
elif uname -a | grep -q "Darwin"; then
    echo "${YELLOW}Running on macOS - partial compatibility.${NC}"
else
    echo "${RED}Unknown operating system - compatibility not guaranteed.${NC}"
fi

# Test shell scripts with shellcheck
echo "${YELLOW}Testing shell scripts with shellcheck...${NC}"
if command -v shellcheck &> /dev/null; then
    SHELL_SCRIPTS=$(find "$DOTFILES_DIR" -name "*.sh")
    for script in $SHELL_SCRIPTS; do
        echo -n "Checking $(basename "$script")... "
        if shellcheck "$script"; then
            echo "${GREEN}PASS${NC}"
        else
            echo "${RED}FAIL${NC}"
            exit 1
        fi
    done
else
    echo "${YELLOW}shellcheck not installed. Skipping shell script tests.${NC}"
    echo "On FreeBSD: pkg install shellcheck"
fi

# Test symlinks
echo "${YELLOW}Testing symlinks...${NC}"
declare -A FILES_TO_CHECK
FILES_TO_CHECK[".bash_profile"]="$DOTFILES_DIR/shell/.bash_profile"
FILES_TO_CHECK[".bashrc"]="$DOTFILES_DIR/shell/.bashrc"
FILES_TO_CHECK[".profile"]="$DOTFILES_DIR/shell/.profile"
FILES_TO_CHECK[".zshrc"]="$DOTFILES_DIR/shell/.zshrc"
FILES_TO_CHECK[".tmux.conf"]="$DOTFILES_DIR/tmux/.tmux.conf"
FILES_TO_CHECK[".emacs.d/init.el"]="$DOTFILES_DIR/editors/emacs/init.el"

for file in "${!FILES_TO_CHECK[@]}"; do
    source_file="${FILES_TO_CHECK[$file]}"
    target_file="$HOME/$file"
    
    echo -n "Checking $target_file... "
    if [ -L "$target_file" ]; then
        link_target=$(readlink "$target_file")
        if [ "$link_target" = "$source_file" ]; then
            echo "${GREEN}PASS${NC}"
        else
            echo "${RED}FAIL${NC} (points to $link_target instead of $source_file)"
        fi
    else
        echo "${RED}FAIL${NC} (not a symlink)"
    fi
done

# Test AYGP directory structure
echo "${YELLOW}Testing AYGP directory structure...${NC}"
for dir in journal tools sandbox reports logs; do
    echo -n "Checking ~/.anthropic/$dir... "
    if [ -d "$HOME/.anthropic/$dir" ]; then
        echo "${GREEN}PASS${NC}"
    else
        echo "${RED}FAIL${NC} (directory not found)"
    fi
done

# Test Emacs configuration
echo "${YELLOW}Testing Emacs configuration...${NC}"
if command -v emacs &> /dev/null; then
    echo -n "Testing init.el load... "
    if emacs --batch --eval "(progn (load-file \"$HOME/.emacs.d/init.el\") (message \"Success\"))" 2>&1 | grep -q "Success"; then
        echo "${GREEN}PASS${NC}"
    else
        echo "${RED}FAIL${NC} (error loading init.el)"
    fi
    
    # Check for Lisp packages
    echo -n "Checking for SLIME... "
    if [ -d "$HOME/.emacs.d/elpa/slime-"* ] || emacs --batch --eval "(require 'slime)" 2>/dev/null; then
        echo "${GREEN}PASS${NC}"
    else
        echo "${YELLOW}MISSING${NC} (SLIME not installed - Common Lisp support unavailable)"
    fi
    
    echo -n "Checking for Paredit... "
    if [ -d "$HOME/.emacs.d/elpa/paredit-"* ] || emacs --batch --eval "(require 'paredit)" 2>/dev/null; then
        echo "${GREEN}PASS${NC}"
    else
        echo "${YELLOW}MISSING${NC} (Paredit not installed - structured editing unavailable)"
    fi
else
    echo "${RED}Emacs not installed. Cannot test Emacs configuration.${NC}"
fi

# Test bin scripts
echo "${YELLOW}Testing bin scripts...${NC}"
if [ -d "$DOTFILES_DIR/bin" ]; then
    for script in "$DOTFILES_DIR"/bin/*; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            script_name=$(basename "$script")
            echo -n "Checking $script_name... "
            if [ -L "$HOME/bin/$script_name" ]; then
                echo "${GREEN}PASS${NC}"
            else
                echo "${RED}FAIL${NC} (not linked in ~/bin)"
            fi
        fi
    done
else
    echo "${YELLOW}No bin directory found.${NC}"
fi

echo "${BLUE}Dotfiles configuration tests complete.${NC}"