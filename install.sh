#!/bin/bash
#
# install.sh - Symlink dotfiles into $HOME
#
# Usage:
#   ./install.sh          # interactive mode (prompts on conflicts)
#   ./install.sh --force  # non-interactive (backs up conflicts automatically)
#

set -euo pipefail

DOTDIR="$(cd "$(dirname "$0")" && pwd)"
FORCE=false

for arg in "$@"; do
    case "$arg" in
        --force|-f) FORCE=true ;;
        *) echo "Unknown argument: $arg" >&2; exit 1 ;;
    esac
done

for symlink in $(find "$DOTDIR" \( -name "*.symlink" ! -path "*.git*" \)); do
    echo "Processing $symlink"
    dotfile=".$(basename "$symlink" .symlink)"
    target="$(readlink -f "$symlink")"
    create_link=true

    if [ -h ~/"$dotfile" ]; then
        if [ "$FORCE" = true ]; then
            echo "Unlinking existing ~/$dotfile"
            unlink ~/"$dotfile"
        else
            echo "~/$dotfile is already a symlink."
            echo "Unlink? [Y]es, [N]o"
            read -r answer
            if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
                unlink ~/"$dotfile"
            else
                echo "Skipping ~/$dotfile"
                create_link=false
            fi
        fi
    elif [ -e ~/"$dotfile" ]; then
        if [ "$FORCE" = true ]; then
            echo "Backing up ~/$dotfile to ~/.dotfiles.bak/$dotfile"
            mkdir -p ~/.dotfiles.bak
            mv ~/"$dotfile" ~/.dotfiles.bak/
        else
            echo "~/$dotfile already exists."
            echo "What should be done? [B]ackup, [S]kip"
            read -r answer
            if [[ "$answer" == "B" || "$answer" == "b" ]]; then
                echo "Backing up ~/$dotfile to ~/.dotfiles.bak/$dotfile"
                mkdir -p ~/.dotfiles.bak
                mv ~/"$dotfile" ~/.dotfiles.bak/
            else
                echo "Skipping ~/$dotfile"
                create_link=false
            fi
        fi
    fi

    if $create_link; then
        echo "Linking ~/$dotfile --> $target"
        ln -s -T "$target" ~/"$dotfile"
    fi
done
