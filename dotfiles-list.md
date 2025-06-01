# Core Dotfiles to Include

## Shell Configuration
- .bash_profile
- .bashrc
- .profile
- .shrc
- .zshrc
- .zshrc.pre-oh-my-zsh
- .oh-my-zsh (directory)
- .fzf.bash
- .fzf.bash.local
- .fzf.zsh

## Editor Configuration
- .vimrc (if present)
- .emacs.d (directory structure, without sensitive data)
- .config/nvim (if present)

## Git Configuration
- .gitconfig (sanitized version without personal tokens)

## Terminal & Utility Configuration
- .tmux.conf
- .xinitrc
- .login
- .login_conf

## XDG Configuration
- .config/... (selected directories, excluding sensitive configs)

## Custom Scripts
- ~/bin/ (directory, excluding any scripts with hardcoded credentials)

## DO NOT INCLUDE (SENSITIVE):
- .authinfo
- .authinfo.template
- .netrc
- .pinerc
- .gnupg (contents)
- .ssh (contents)
- .smb-credentials-*
- .webdav-*
- .envrc
- .claude.json
- Any files containing tokens, passwords or API keys