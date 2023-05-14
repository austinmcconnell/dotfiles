#!/bin/bash

if ! is-executable brew; then
    echo "**************************************************"
    echo "Skipping macOS app installs"
    echo "**************************************************"
    return
else
    echo "**************************************************"
    echo "Installing macOS apps"
    echo "**************************************************"
fi

# Mac App Store application
mas install 1236045954 # Canary mail
mas install 926036361  # Lastpass
mas install 1289583905 # Pixelmator Pro
mas install 1303222628 # Paprika Recipe Manager 3
mas install 714196447  # Menubar Stats

# Safari Extensions
mas install 1481669779 # Evernote Web Clipper
mas install 957810159  # Raindrop.io for Safari
