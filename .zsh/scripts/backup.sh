#!/bin/bash

# --- Configuration ---
REPO_URL="https://github.com/jonathan6620/zsh-backup.git" 
BACKUP_DIR="$HOME/zsh-backup"       
ZSH_DIR="$HOME/.oh-my-zsh"         

# Add any other directories you want to back up
EXTRA_DIRS=("$HOME/.zshrc" "$HOME/.zsh" "$HOME/.zshenv" "$HOME/.aliases")

# --- Functions ---

# Function to add a file or directory to the backup
add_to_backup() {
  local item="$1"
  local relative_path="${item/#$HOME\//}"  # Remove $HOME prefix for relative path
  local target_path="$BACKUP_DIR/$relative_path"

  if [ -f "$item" ]; then
    echo "Adding file: $item"
    mkdir -p "$(dirname "$target_path")"  # Create directory structure if needed
    cp "$item" "$target_path"
  elif [ -d "$item" ]; then
    echo "Adding directory: $item"
    cp -r "$item" "$target_path"
  else
    echo "Warning: Item not found: $item"
  fi
}

# --- Main Script ---

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# 1. Backup Oh My Zsh (if applicable)
if [ -d "$ZSH_DIR" ]; then
  add_to_backup "$ZSH_DIR"
fi

# 2. Backup Files in EXTRA_DIRS
for dir in "${EXTRA_DIRS[@]}"; do
  add_to_backup "$dir"
done

# 3. Create a .gitignore
cat << EOF > "$BACKUP_DIR/.gitignore"
*.local
*.log
.DS_Store
# Add any other files/patterns you want to exclude
EOF

# 4. Git operations
cd "$BACKUP_DIR"

if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    git remote add origin "$REPO_URL"
fi

git add --all 
git commit -m "Zsh backup: $(date)"
git push -u origin main

echo "Backup complete!"
