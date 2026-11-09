#!/bin/bash

source "$DOTFILES_DIR/install/utils.sh"

echo "**************************************************"
echo "Installing dircolors themes"
echo "**************************************************"

mkdir -p "$HOME/.dircolors"

# Link vendored themes
link_and_verify "$DOTFILES_DIR/etc/dircolors/nord" "$HOME/.dircolors/nord" || return 1
link_and_verify "$DOTFILES_DIR/etc/dircolors/bliss" "$HOME/.dircolors/bliss" || return 1

# Set default theme (options: nord, bliss)
DEFAULT_THEME="nord"
link_and_verify "$HOME/.dircolors/$DEFAULT_THEME" "$HOME/.dir_colors" || return 1
