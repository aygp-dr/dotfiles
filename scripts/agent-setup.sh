#!/bin/bash
# Script to set up AYGP agent environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AYGP_MANUAL_PATH="/home/jwalsh/projects/aygp-dr/aygp-dr/docs/aygp-user-manual.md"

echo -e "${BLUE}Setting up AYGP agent environment...${NC}"

# Create AYGP directory structure
echo -e "${YELLOW}Creating AYGP directory structure...${NC}"
mkdir -p "$HOME/.anthropic/journal"
mkdir -p "$HOME/.anthropic/tools"
mkdir -p "$HOME/.anthropic/sandbox"
mkdir -p "$HOME/.anthropic/reports"
mkdir -p "$HOME/.anthropic/logs"

# Create initial journal entry
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
cat > "$HOME/.anthropic/journal/$(date +"%Y%m%d").md" << EOF
# Daily Log: $(date +"%Y-%m-%d")

## Environment Setup
- Initialized AYGP agent environment at $TIMESTAMP
- Configured dotfiles from $DOTFILES_DIR

## Current Status
- Environment: Active
- Identity: AYGP (Automated Yet Guided Process)
- GitHub: @aygp-dr
- Email: apace@defrecord.com

## Tasks
- [ ] Complete environment configuration
- [ ] Verify GitHub access
- [ ] Test WebDAV/S3 synchronization
- [ ] Set up notification channels

## Notes
Initial setup by human operator (jwalsh).
EOF

echo -e "${GREEN}Created initial journal entry.${NC}"

# Set up agent specific aliases
cat > "$DOTFILES_DIR/shell/agent-aliases.sh" << EOF
# AYGP agent-specific aliases and functions

# Quick navigation
alias cdj='cd ~/.anthropic/journal'
alias cdt='cd ~/.anthropic/tools'
alias cds='cd ~/.anthropic/sandbox'
alias cdr='cd ~/.anthropic/reports'
alias cdl='cd ~/.anthropic/logs'

# Journal functions
aygp-journal() {
  local DATE=\$(date +"%Y%m%d")
  if [ -n "\$1" ]; then
    DATE="\$1"
  fi
  
  vim ~/.anthropic/journal/\${DATE}.md
}

# Status reporting
aygp-status() {
  echo "AYGP Status Report: \$(date)"
  echo "-------------------------"
  echo "Journal Entries: \$(ls -1 ~/.anthropic/journal/ | wc -l)"
  echo "Tools Available: \$(ls -1 ~/.anthropic/tools/ | wc -l)"
  echo "Recent Activity:"
  find ~/.anthropic -type f -mtime -1 | sort
}

# GitHub helper
aygp-gh() {
  GH_TOKEN=\$(cat ~/.config/aygp/github_token 2>/dev/null || echo "")
  if [ -z "\$GH_TOKEN" ]; then
    echo "GitHub token not configured. Please add token to ~/.config/aygp/github_token"
    return 1
  fi
  
  GH_TOKEN=\$GH_TOKEN gh "\$@"
}
EOF

echo -e "${GREEN}Created agent-specific aliases.${NC}"

# Add agent-aliases.sh to shell configuration
for shell_rc in "$DOTFILES_DIR/shell/.bashrc" "$DOTFILES_DIR/shell/.zshrc"; do
  if [ -f "$shell_rc" ]; then
    if ! grep -q "agent-aliases.sh" "$shell_rc"; then
      echo "" >> "$shell_rc"
      echo "# Load AYGP agent aliases" >> "$shell_rc"
      echo "[ -f ~/.dotfiles/shell/agent-aliases.sh ] && source ~/.dotfiles/shell/agent-aliases.sh" >> "$shell_rc"
      echo -e "${GREEN}Added agent aliases to $(basename "$shell_rc")${NC}"
    fi
  fi
done

# Create AYGP config directory
mkdir -p "$HOME/.config/aygp"

# Create placeholder for GitHub token
touch "$HOME/.config/aygp/github_token"
chmod 600 "$HOME/.config/aygp/github_token"
echo -e "${YELLOW}Created placeholder for GitHub token at ~/.config/aygp/github_token${NC}"
echo -e "${YELLOW}Please add your GitHub token to this file for AYGP GitHub integration.${NC}"

echo -e "${GREEN}AYGP agent environment setup complete!${NC}"
echo -e "${BLUE}Run 'source ~/.bashrc' or 'source ~/.zshrc' to load the new configuration.${NC}"