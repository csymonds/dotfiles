#!/bin/bash
#
# init.sh - Ubuntu 24.04 environment setup
#
# Installs system packages and initializes dotfiles.
# Designed to be non-interactive for Docker/CI use.
#
# Usage:
#   ./init.sh          # full install (apt + dotfiles)
#   ./init.sh --no-apt # skip apt install, just set up dotfiles
#

set -euo pipefail

DOTDIR="$(cd "$(dirname "$0")" && pwd)"

# ---- Helpers ----
info()  { echo "[init] $*"; }
error() { echo "[init] ERROR: $*" >&2; }

# ---- Parse args ----
SKIP_APT=false
for arg in "$@"; do
    case "$arg" in
        --no-apt) SKIP_APT=true ;;
        *) error "Unknown argument: $arg"; exit 1 ;;
    esac
done

# ---- APT packages ----
if [ "$SKIP_APT" = false ]; then
    info "Installing apt packages..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq \
        build-essential \
        cmake \
        ninja-build \
        vim \
        tmux \
        curl \
        git \
        fzf \
        ripgrep \
        cdargs \
        clangd \
        clang-format \
        python3 \
        python3-pip
    info "apt packages installed."
fi

# ---- Git submodules (vim plugins) ----
info "Initializing vim plugin submodules..."
cd "$DOTDIR"
git submodule init
git submodule update --recursive
info "Vim plugins ready."

# ---- Install dotfile symlinks ----
info "Installing dotfile symlinks..."
"$DOTDIR/install.sh" --force
info "Symlinks installed."

# ---- fzf key bindings ----
# fzf from apt includes shell integration files;
# bashrc sources them automatically.

info "Done. Start a new shell or run: source ~/.bashrc"
