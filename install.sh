#!/bin/zsh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Files to install: "source:target" pairs
FILES=(
  "zshrc:$HOME/.zshrc"
  "zshenv:$HOME/.zshenv"
  "aliases:$HOME/.aliases"
  "gitignore:$HOME/.gitignore"
  "zsh:$HOME/.zsh"
  "config/zellij:$HOME/.config/zellij"
  "gitconfig:$HOME/.gitconfig"
)

copy_item() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ]; then
    local backup="${dest}.bak"
    echo "  backing up: $dest -> $backup"
    mv "$dest" "$backup"
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -d "$src" ]; then
    cp -r "$src" "$dest"
  else
    cp "$src" "$dest"
  fi
  echo "  installed: $dest"
}

echo "==> Installing dotfiles from $SCRIPT_DIR"
echo ""

for entry in "${FILES[@]}"; do
  file="${entry%%:*}"
  dest="${entry#*:}"
  src="$SCRIPT_DIR/$file"

  if [ ! -e "$src" ]; then
    echo "  skip: $src (not found)"
    continue
  fi

  copy_item "$src" "$dest"
done

echo ""
echo "==> Installing oh-my-zsh (if needed)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "  ok: oh-my-zsh already installed"
fi

echo ""
echo "==> Installing oh-my-zsh plugins"
"$SCRIPT_DIR/zsh/scripts/install-omz-plugins.sh"

echo ""
echo "==> Installing Homebrew (if needed)"
if ! command -v brew &>/dev/null; then
  echo "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "  ok: Homebrew already installed"
fi

echo ""
echo "==> Installing tools via Homebrew"
brew_packages=(bat gh nvm zellij)
for pkg in "${brew_packages[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "  ok: $pkg already installed"
  else
    echo "  Installing $pkg..."
    brew install "$pkg"
  fi
done

echo ""
echo "==> Setting up Node via nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
if command -v nvm &>/dev/null; then
  if nvm ls --no-colors default &>/dev/null 2>&1; then
    echo "  ok: Node $(nvm version default) already installed"
  else
    echo "  Installing Node LTS..."
    nvm install --lts
  fi
else
  echo "  warning: nvm not available — skipping Node install"
fi

echo ""
echo "==> Installing pnpm (if needed)"
if command -v pnpm &>/dev/null; then
  echo "  ok: pnpm already installed"
else
  echo "  Installing pnpm..."
  npm install -g pnpm
fi

echo ""
echo "==> Installing Rust (if needed)"
if command -v rustup &>/dev/null; then
  echo "  ok: Rust already installed"
else
  echo "  Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
fi

echo ""
echo "==> Installing Go (if needed)"
if brew list go &>/dev/null; then
  echo "  ok: Go already installed"
else
  echo "  Installing Go..."
  brew install go
fi

echo ""
echo "==> Installing Miniconda (if needed)"
if brew list --cask miniconda &>/dev/null; then
  echo "  ok: miniconda already installed"
else
  echo "  Installing miniconda..."
  brew install --cask miniconda
fi
eval "$(/opt/homebrew/Caskroom/miniconda/base/bin/conda shell.zsh hook)"
conda init zsh

echo ""
echo "==> Installing PyMOL conda environment (if needed)"
if conda env list | grep -q "pymol-env"; then
  echo "  ok: pymol-env already exists"
else
  echo "  Creating pymol-env and installing PyMOL..."
  conda create -y -n pymol-env pymol-open-source -c conda-forge
fi

echo ""
echo "==> Configuring keyboard responsiveness"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write -g ApplePressAndHoldEnabled -bool false
echo "  set: KeyRepeat=1, InitialKeyRepeat=10, ApplePressAndHoldEnabled=false"
echo "  note: log out and back in for key repeat changes to take effect"

echo ""
echo "==> Done! Restart your shell or run: source ~/.zshrc"
