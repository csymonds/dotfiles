#!/bin/bash

echo "Setting up environment for EC2 Amazon Linux 2023"

# Check if we're running as root
if [ "$EUID" -ne 0 ]; then
  echo "Some steps require sudo. You may be prompted for your password."
fi

# Install essential packages
echo "Installing essential packages..."
sudo dnf update -y
sudo dnf install -y git vim tmux nodejs gcc make curl wget tar zip unzip

# Basic development tools
sudo dnf group install -y "Development Tools"

# Optional packages - uncomment if needed
# sudo dnf install -y python3-devel

# Create backup directory
echo "Creating backup directory..."
mkdir -p ~/bk

# Backup existing config files
if [ -f ~/.bashrc ]; then
  echo "Backing up existing .bashrc..."
  cp ~/.bashrc ~/bk/bashrc_bk
fi

if [ -f ~/.vimrc ]; then
  echo "Backing up existing .vimrc..."
  cp ~/.vimrc ~/bk/vimrc_bk
fi

# Install dotfiles
echo "Installing dotfiles..."
./install.sh

# Set up vim plugins
echo "Setting up Vim plugins..."
vim +PlugInstall +qall

# Set up CoC extensions for Vim
echo "Installing basic CoC extensions..."
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]; then
  echo '{"dependencies":{}}' > package.json
fi
npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod \
  coc-json coc-tsserver coc-pyright

# Final steps
echo ""
echo "Setup complete! Please log out and back in or run 'source ~/.bashrc' to activate changes."
echo ""
echo "If you need specific language support in Vim, you can add more CoC extensions."
echo "For example, Python: :CocInstall coc-pyright"
echo "JavaScript/TypeScript: :CocInstall coc-tsserver"
echo "See https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions for more options."

