#!/bin/bash

echo "**************************************************"
echo "Installing dircolors themes"
echo "**************************************************"

mkdir -p "$HOME/.dircolors"

# Link vendored themes
ln -sfv "$DOTFILES_DIR/etc/dircolors/nord" "$HOME/.dircolors/nord"
ln -sfv "$DOTFILES_DIR/etc/dircolors/bliss" "$HOME/.dircolors/bliss"

# Set default theme (options: nord, bliss)
DEFAULT_THEME="nord"
ln -sfv "$HOME/.dircolors/$DEFAULT_THEME" "$HOME/.dir_colors"
