#!/bin/bash

echo "**************************************************"
echo "Installing Nord dircolors"
echo "**************************************************"

REPO_DIR="$HOME/.repositories/nord-dircolors"
if [ -d "$REPO_DIR/.git" ]; then
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin
else
    git clone https://github.com/nordtheme/dircolors "$REPO_DIR"
    ln -sfv "$REPO_DIR/src/dir_colors" "$HOME/.dir_colors"
fi
