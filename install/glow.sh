#!/bin/bash

echo "**************************************************"
echo "Configuring Glow markdown viewer"
echo "**************************************************"

if ! is-executable glow; then
    if is-macos; then
        echo "Installing Glow with brew..."
        brew install glow
    elif is-debian; then
        echo "Installing Glow..."
        # For Debian-based systems, you might need to use a different installation method
        # Check if snap is available
        if is-executable snap; then
            sudo snap install glow
        else
            echo "Please install glow manually on this Debian system"
            echo "Visit: https://github.com/charmbracelet/glow#installation"
        fi
    else
        echo "Skipping Glow installation: Unidentified OS"
        return
    fi
fi

# Create config directory if it doesn't exist
mkdir -p "$HOME/.config/glow"

# Link configuration file
ln -sfv "$DOTFILES_DIR/etc/glow/glow.yml" "$HOME/.config/glow/glow.yml"

echo "Glow configuration complete"
