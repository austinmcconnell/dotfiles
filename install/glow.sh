#!/bin/bash

echo "**************************************************"
echo "Configuring Glow markdown viewer"
echo "**************************************************"

if ! is-executable glow; then
    echo "Warning: glow not found, skipping configuration"
    return
fi

# Create config directory if it doesn't exist
mkdir -p "$HOME/.config/glow"

# Link configuration file
ln -sfv "$DOTFILES_DIR/etc/glow/glow.yml" "$HOME/.config/glow/glow.yml"

echo "Glow configuration complete"
