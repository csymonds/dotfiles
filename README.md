# Modern Dotfiles for Amazon EC2

My dot files repo updated for Amazon Linux 2023 on EC2.
There are many like it, but this one is mine.

## Features

- Modern Vim configuration with Vim-Plug for plugin management
- CoC (Conquer of Completion) for code completion and language server integration
- Useful bash aliases and functions for improved productivity
- Simple installation process

## Installation

1. Clone this repository to your EC2 instance:
   ```
   git clone https://github.com/csymonds/dotfiles.git ~/.dotfiles
   ```

2. Run the initialization script:
   ```
   cd ~/.dotfiles
   chmod +x init.sh
   ./init.sh
   ```

3. The script will:
   - Install necessary packages
   - Back up existing configuration files
   - Create symlinks for all dotfiles
   - Set up Vim plugins
   - Configure CoC extensions

## Structure

- `vim/` - Vim configuration files
- `bash/` - Bash configuration files
- `cdargs/` - CDargs for faster directory navigation
- `install.sh` - Script to create symlinks for dotfiles
- `init.sh` - Script to install necessary packages and set up environment

## Quick Tips

- Many useful bash functions are available (try `weather`, `extract`, `ff`, etc.)
- The Vim configuration includes many quality-of-life improvements:
  - Use `jj` to escape insert mode
  - `<C-p>` for fuzzy file finding
  - CoC completion with tab navigation

## Customization

Feel free to modify these files to suit your preferences. The modular organization makes it easy to update specific components.

Originally based on [jcrussell's dotfiles](https://github.com/jcrussell/dotfiles.git), now significantly updated for modern environments.
