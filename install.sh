#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
DOTFILES_EXTRA_DIR="$HOME/.extra"

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles itself first
if is-executable git -a -d "$DOTFILES_DIR/.git"; then
	git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master;
fi

# Bunch of symlinks
ln -sfv "$DOTFILES_DIR/runcom/.zshrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.ctags" ~

if ! is-executable brew; then
  echo "Homebrew not found. Installing..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Package managers & packages
. "$DOTFILES_DIR/install/zsh.sh"
. "$DOTFILES_DIR/install/git.sh"
. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/brew-cask.sh"
. "$DOTFILES_DIR/install/python.sh"
# . "$DOTFILES_DIR/install/nvm.sh"
. "$DOTFILES_DIR/install/vim.sh"


mkdir ~/.config
touch ~/.hushlogin

# Run tests
if is-executable bats; then bats test/*.bats; else echo "Skipped: tests (missing: bats)"; fi
