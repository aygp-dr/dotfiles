# Dotfiles for Emacs/Lisp-focused Environment

## Identity & Authorization
- Identity retrieval: `gh api user` to fetch GitHub identity information
- Agent identity: Use AYGP identity from user manual
- Authorization: Set up GPG/SSH keys as per AYGP user manual
- Validation: `make check-identity` to validate identity configuration

## Environment Information
- Primary platform: **FreeBSD 14.2-RELEASE**
- Additional platforms: Linux, macOS (occasional use)
- Main editor: **Emacs** with extensive customization
- Shell: Bash/Zsh with FreeBSD-specific configurations
- Version control: Git with GitHub integration

## FreeBSD Package Requirements
- emacs (required): `pkg install emacs`
- git (required): `pkg install git`
- verbiste (optional): `pkg install verbiste` - French/Italian verb conjugation
- sbcl (optional): `pkg install sbcl` - Common Lisp development
- rlwrap (recommended): `pkg install rlwrap` - Better REPL experience

## Emacs Configuration Guidelines
- Use `init.el` for main configuration
- Custom functions go in `./lisp/` directory 
- Autoloads for improved startup performance
- org-mode as primary organization tool
- SLIME/SLY for Common Lisp development
- CIDER for Clojure development
- Properly namespaced functions with `aygp-` prefix

## Build & Test Commands
- **Installation**: `make install` or `./install.sh` to bootstrap environment
- **Validation**: `make check-identity` to verify identity configuration
- **Test Emacs config**: `make test-emacs` to validate Emacs setup
- **Test single file**: `emacs --batch --load-file "/path/to/file.el"`
- **Lint Emacs Lisp**: `make check-lisp` to check Emacs Lisp code
- **Test all configs**: `make test` or `make test-config` to verify all settings
- **Update**: `git pull && make update` to sync latest configurations
- **Reset**: `make reset` to restore environment to baseline state

## Directory Structure
- Use existing ~/.anthropic from dotanthropic project
- ~/.emacs.d/ for Emacs configuration
- ~/.config/ for XDG-compliant configurations
- ~/bin/ for user scripts and utilities

## Lisp Development Standards
- Use meaningful names with proper documentation
- Include docstrings for all functions
- Manage dependencies explicitly
- Follow consistent indentation (2 spaces for Lisp)
- Test all functions when possible
- Prefer functional programming patterns

## Code Style Guidelines
- **Emacs Lisp**: 
  - Two-space indentation, no tabs (`setq-default indent-tabs-mode nil`)
  - Require proper packages at top of files
  - Follow naming conventions: `aygp-module-function-name`
  - Provide docstrings for all functions and variables
  - End files with `(provide 'module-name)` and `;;; file-name.el ends here`
- **Shell Scripts**:
  - Use POSIX-compliant `/bin/sh` for portability
  - Use shellcheck for validating scripts
  - Apply error handling with `set -e` and explicit checks
  - Set proper file permissions with `chmod +x` before execution
- **Documentation**:
  - Use Org mode for documentation (`.org` files)
  - Include purpose, usage, and examples in all utilities
  - Follow AYGP identity and commit guidelines
- **Security**:
  - Maintain separation between agent and human contexts
  - Document proper privileges for all scripts
  - Make all configuration scripts idempotent (safely re-runnable)

## Collaboration Guidelines
- Maintain separation between human and agent workspaces
- Document all complex Lisp functions with examples
- Use feature branches for development
- Follow FreeBSD port conventions when applicable
- Ensure cross-platform compatibility in shell scripts

## Integration Points
- Emacs server for client connections
- org-protocol for capturing from browser
- TRAMP for remote editing
- Magit for Git operations
- org-babel for literate programming

This environment supports fluid collaboration between human operators (primarily jwalsh) and autonomous agents, with a strong focus on Emacs and Lisp development on FreeBSD.
