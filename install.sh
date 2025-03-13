#!/bin/bash

# Get the directory where the script is located
DOTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
echo "Installing dotfiles from $DOTDIR"

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles.bak/$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Process all symlink files
find "$DOTDIR" -name "*.symlink" ! -path "*.git*" | while read -r symlink; do
  dotfile=".$(basename "$symlink" .symlink)"
  echo "Processing $dotfile"
  
  # Handle existing files/links
  if [ -e "$HOME/$dotfile" ] || [ -L "$HOME/$dotfile" ]; then
    echo "Backing up existing $HOME/$dotfile to $BACKUP_DIR/"
    mv "$HOME/$dotfile" "$BACKUP_DIR/"
  fi
  
  # Create the symlink
  target=$(realpath "$symlink")
  echo "Creating symlink: $HOME/$dotfile -> $target"
  ln -s "$target" "$HOME/$dotfile"
done

# Setup vim-plug
if [ ! -e "$HOME/.vim/autoload/plug.vim" ]; then
  echo "Installing vim-plug..."
  mkdir -p "$HOME/.vim/autoload"
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Create notes directory for vim-notes if it doesn't exist
mkdir -p "$HOME/.notes"

echo ""
echo "Dotfiles installation complete!"
echo "Next steps:"
echo "1. Start vim and run :PlugInstall to install plugins"
echo "2. For CoC functionality, ensure Node.js is installed"
echo "   (sudo dnf install nodejs)"
echo "3. Source your .bashrc with: source ~/.bashrc"
