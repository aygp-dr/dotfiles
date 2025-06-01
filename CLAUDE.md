# Dotfiles for Agent-Driven Development

## Build & Test Commands
- **Installation**: `make install` or `./install.sh` to bootstrap environment
- **Validation**: `make check-identity` to verify identity configuration
- **Test Emacs config**: `make test-emacs` to validate Emacs setup
- **Test single file**: `emacs --batch --load-file "/path/to/file.el"`
- **Lint Emacs Lisp**: `make check-lisp` to check Emacs Lisp code
- **Test all configs**: `make test` or `make test-config` to verify all settings
- **Update**: `git pull && make update` to sync latest configurations
- **Reset**: `make reset` to restore environment to baseline state

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

This environment supports fluid collaboration between AYGP and human operators while maintaining security boundaries. For complete details on protocols and integration, see the AYGP user manual.