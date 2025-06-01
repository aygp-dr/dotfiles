#!/bin/bash
# Script to reset environment to baseline state

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${BLUE}Resetting environment to baseline state...${NC}"
echo -e "${YELLOW}Warning: This will archive current AYGP data and restore to a clean state.${NC}"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Reset cancelled.${NC}"
    exit 1
fi

# Archive current AYGP data
ARCHIVE_DIR="$HOME/.anthropic.archive.$(date +%Y%m%d%H%M%S)"
if [ -d "$HOME/.anthropic" ]; then
    echo -e "${YELLOW}Archiving current AYGP data to $ARCHIVE_DIR${NC}"
    mv "$HOME/.anthropic" "$ARCHIVE_DIR"
fi

# Recreate AYGP directory structure
echo -e "${GREEN}Creating fresh AYGP directory structure...${NC}"
mkdir -p "$HOME/.anthropic/journal"
mkdir -p "$HOME/.anthropic/tools"
mkdir -p "$HOME/.anthropic/sandbox"
mkdir -p "$HOME/.anthropic/reports"
mkdir -p "$HOME/.anthropic/logs"

# Create reset marker
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
cat > "$HOME/.anthropic/RESET_MARKER" << EOF
Environment reset at $TIMESTAMP
Reset performed by $(whoami)
Previous data archived at $ARCHIVE_DIR
EOF

# Create initial journal entry after reset
cat > "$HOME/.anthropic/journal/$(date +"%Y%m%d").md" << EOF
# Daily Log: $(date +"%Y-%m-%d")

## Environment Reset
- Environment reset performed at $TIMESTAMP
- Previous data archived at $ARCHIVE_DIR
- Fresh configuration from $DOTFILES_DIR

## Current Status
- Environment: Baseline
- Identity: AYGP (Automated Yet Guided Process)
- GitHub: @aygp-dr
- Email: apace@defrecord.com

## Post-Reset Tasks
- [ ] Verify environment configuration
- [ ] Re-establish GitHub access
- [ ] Re-configure WebDAV/S3 synchronization
- [ ] Re-establish notification channels

## Notes
Reset performed by human operator ($(whoami)).
EOF

echo -e "${GREEN}Created reset journal entry.${NC}"

# Reset agent-specific configuration
echo -e "${YELLOW}Resetting agent-specific configuration...${NC}"
mkdir -p "$HOME/.config/aygp"
rm -f "$HOME/.config/aygp/github_token"
touch "$HOME/.config/aygp/github_token"
chmod 600 "$HOME/.config/aygp/github_token"

echo -e "${GREEN}Environment reset complete!${NC}"
echo -e "${BLUE}Previous data archived at:${NC} $ARCHIVE_DIR"
echo -e "${BLUE}Run 'make agent-setup' to reconfigure AYGP-specific tooling${NC}"