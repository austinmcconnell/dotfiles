#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_EXTRA_DIR="$HOME/.extra"
XDG_CONFIG_HOME="$HOME/.config"

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles itself first
if is-executable git -a -d "$DOTFILES_DIR/.git"; then
    git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin main
fi

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p ~/.repositories

# Package managers & packages
. "$DOTFILES_DIR/install/git.sh"
. "$DOTFILES_DIR/install/zsh.sh"
. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/macos/apps.sh"
. "$DOTFILES_DIR/install/apt.sh"
. "$DOTFILES_DIR/install/python.sh"
. "$DOTFILES_DIR/install/node.sh"
. "$DOTFILES_DIR/install/vim.sh"

touch ~/.hushlogin

# Run tests
if is-executable zunit; then zunit; else echo "Skipped: tests (missing: zunit)"; fi
