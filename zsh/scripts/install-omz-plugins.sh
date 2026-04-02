#!/bin/bash

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

plugins=(
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
)

for plugin in "${plugins[@]}"; do
  name="${plugin##*/}"
  dest="$ZSH_CUSTOM/plugins/$name"
  if [ -d "$dest" ]; then
    echo "$name already installed"
  else
    echo "Installing $name..."
    git clone "https://github.com/$plugin.git" "$dest"
  fi
done

echo "Done. Restart your shell or run: source ~/.zshrc"
