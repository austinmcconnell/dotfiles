#!/bin/bash

echo "**************************************************"
echo "Installing dircolors themes"
echo "**************************************************"

# Create directory for dircolors themes
mkdir -p "$HOME/.dircolors"

# Install Nord dircolors theme
REPO_DIR="$HOME/.repositories/nord-dircolors"
if [ -d "$REPO_DIR/.git" ]; then
    echo "Updating Nord dircolors theme..."
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin
else
    echo "Installing Nord dircolors theme..."
    git clone https://github.com/nordtheme/dircolors "$REPO_DIR"
fi
# Link Nord theme to dircolors directory
ln -sfv "$REPO_DIR/src/dir_colors" "$HOME/.dircolors/nord"

# Install Bliss dircolors theme
REPO_DIR="$HOME/.repositories/bliss-dircolors"
if [ -d "$REPO_DIR/.git" ]; then
    echo "Updating Bliss dircolors theme..."
    git --work-tree="$REPO_DIR" --git-dir="$REPO_DIR/.git" pull origin
else
    echo "Installing Bliss dircolors theme..."
    git clone https://github.com/joshjon/bliss-dircolors "$REPO_DIR"
fi
# Link Bliss theme to dircolors directory
ln -sfv "$REPO_DIR/bliss.dircolors" "$HOME/.dircolors/bliss"

# Set default theme (can be changed in zsh config)
# Options: nord, bliss
DEFAULT_THEME="nord"
ln -sfv "$HOME/.dircolors/$DEFAULT_THEME" "$HOME/.dir_colors"

echo "Installed dircolors themes: nord, bliss"
echo "Default theme set to: $DEFAULT_THEME"
echo "To change theme, update the symlink at ~/.dir_colors"
echo "or modify your shell configuration to use a specific theme."
