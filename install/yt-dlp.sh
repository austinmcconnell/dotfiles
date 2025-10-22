#!/bin/bash

echo "**************************************************"
echo "Configuring yt-dlp"
echo "**************************************************"

if ! is-executable yt-dlp; then
    if is-macos; then
        echo "Installing yt-dlp with brew..."
        brew install yt-dlp
    elif is-debian; then
        echo "Installing yt-dlp..."
        # For Debian-based systems, use pip or package manager
        if is-executable pip3; then
            pip3 install --user yt-dlp
        else
            echo "Please install yt-dlp manually on this Debian system"
            echo "Visit: https://github.com/yt-dlp/yt-dlp#installation"
        fi
    else
        echo "Skipping yt-dlp installation: Unidentified OS"
        return
    fi
fi

# Create config directory if it doesn't exist
mkdir -p "$HOME/.config/yt-dlp"

# Link configuration file
ln -sfv "$DOTFILES_DIR/etc/yt-dlp/yt-dlp.conf" "$HOME/.config/yt-dlp/config"

echo "yt-dlp configuration complete"
