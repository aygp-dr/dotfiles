#!/bin/sh
# Script to validate AYGP identity configuration on FreeBSD

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

AYGP_MANUAL_PATH="/home/jwalsh/projects/aygp-dr/aygp-dr/docs/aygp-user-manual.md"

echo "${BLUE}Checking identity configuration...${NC}"

# Check system type
echo "${YELLOW}Checking system...${NC}"
if uname -a | grep -q "FreeBSD"; then
    echo "${GREEN}Running on FreeBSD.${NC}"
elif uname -a | grep -q "Linux"; then
    echo "${YELLOW}Running on Linux. Some FreeBSD-specific features may not work.${NC}"
elif uname -a | grep -q "Darwin"; then
    echo "${YELLOW}Running on macOS. Some FreeBSD-specific features may not work.${NC}"
else
    echo "${RED}Unknown operating system.${NC}"
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "${RED}GitHub CLI (gh) is not installed.${NC}"
    echo "Please install it to continue."
    echo "On FreeBSD: pkg install gh"
    exit 1
fi

# Check GitHub login status
echo "${YELLOW}Checking GitHub authentication...${NC}"
if ! gh auth status &> /dev/null; then
    echo "${RED}Not logged in to GitHub.${NC}"
    echo "Please run 'gh auth login' to authenticate."
    exit 1
else
    echo "${GREEN}GitHub authentication successful.${NC}"
    gh api user --jq '.login'
fi

# Check if AYGP manual exists
echo "${YELLOW}Checking for AYGP manual...${NC}"
if [ ! -f "$AYGP_MANUAL_PATH" ]; then
    echo "${RED}AYGP manual not found at:${NC} $AYGP_MANUAL_PATH"
    exit 1
else
    echo "${GREEN}AYGP manual found.${NC}"
fi

# Check for GPG keys
echo "${YELLOW}Checking for GPG keys...${NC}"
if ! gpg --list-secret-keys | grep -q "apace@defrecord.com"; then
    echo "${RED}AYGP GPG key not found.${NC}"
    echo "Please import the GPG key for apace@defrecord.com"
else
    echo "${GREEN}AYGP GPG key found.${NC}"
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format=long apace@defrecord.com | grep sec | awk '{print $2}' | cut -d'/' -f2)
    echo "Key ID: $GPG_KEY_ID"
fi

# Check for SSH keys
echo "${YELLOW}Checking for SSH keys...${NC}"
if [ ! -d "$HOME/.ssh" ] || [ -z "$(ls -A $HOME/.ssh)" ]; then
    echo "${RED}SSH keys not found.${NC}"
    echo "Please set up SSH keys for authentication."
else
    echo "${GREEN}SSH keys found.${NC}"
    ls -la $HOME/.ssh/ | grep -v "authorized_keys\|known_hosts" | grep "id_"
fi

# Check AYGP directory structure
echo "${YELLOW}Checking AYGP directory structure...${NC}"
for dir in journal tools sandbox reports logs; do
    if [ ! -d "$HOME/.anthropic/$dir" ]; then
        echo "${RED}Directory not found:${NC} $HOME/.anthropic/$dir"
    else
        echo "${GREEN}Directory exists:${NC} $HOME/.anthropic/$dir"
    fi
done

# Check for Emacs
echo "${YELLOW}Checking Emacs installation...${NC}"
if ! command -v emacs &> /dev/null; then
    echo "${RED}Emacs not installed.${NC}"
    echo "Please install Emacs to continue."
    echo "On FreeBSD: pkg install emacs"
    exit 1
else
    EMACS_VERSION=$(emacs --version | head -n 1)
    echo "${GREEN}$EMACS_VERSION${NC}"
fi

echo "${BLUE}Identity check complete.${NC}"