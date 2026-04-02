# zsh-backup-mac

Zsh configuration backup for macOS.

## Contents

- `zshrc` — main zsh config (oh-my-zsh, nvm, pnpm, conda, Homebrew)
- `zshenv` — environment variables (bat, Android SDK)
- `aliases` — shell aliases
- `gitignore` — global gitignore
- `config/zellij/config.kdl` — zellij terminal multiplexer config
- `zsh/scripts/backup.sh` — backs up dotfiles to this repo and pushes
- `zsh/scripts/install-omz-plugins.sh` — installs custom oh-my-zsh plugins
- `zsh/scripts/imgcat.sh` — display images in terminal
- `zsh/python/` — utility scripts (get_canonical, get_decimal)
- `zsh/go/gemini/` — Gemini API CLI tool

## Setup

```bash
# Install custom oh-my-zsh plugins
~/.zsh/scripts/install-omz-plugins.sh
```

## Backup

```bash
~/.zsh/scripts/backup.sh
```
