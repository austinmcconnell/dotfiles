#!/bin/bash

echo "**************************************************"
echo "Configuring yt-dlp"
echo "**************************************************"

if ! is-executable yt-dlp; then
    echo "Warning: yt-dlp not found, skipping configuration"
    return
fi

# Create config directory if it doesn't exist
mkdir -p "$HOME/.config/yt-dlp"

# Link configuration file
ln -sfv "$DOTFILES_DIR/etc/yt-dlp/yt-dlp.conf" "$HOME/.config/yt-dlp/config"

echo "yt-dlp configuration complete"
