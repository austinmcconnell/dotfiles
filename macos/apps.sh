#!/bin/sh

if ! is-executable brew; then
    echo "**************************************************"
    echo "Skipping macOS installs: Homebrew not installed"
    echo "**************************************************"
    return
else
    echo "**************************************************"
    echo "Installing macOS apps"
    echo "**************************************************"
fi

# Install applications
brew install --cask atom
brew install --cask betterzip
brew install --cask docker
brew install --cask dozer
brew install --cask dropbox
brew install --cask evernote
brew install --cask flux
brew install --cask font-source-code-pro
brew install --cask google-chrome
brew install --cask google-cloud-sdk
brew install --cask gpg-suite
brew install --cask hazel
brew install --cask hyper
brew install --cask iterm2
brew install --cask keepingyouawake
brew install --cask macdown
brew install --cask oversight
brew install --cask postico
brew install --cask pycharm
brew install --cask slack
brew install --cask spectacle
brew install --cask viscosity
brew install --cask visual-studio-code

ln -sfv "$DOTFILES_DIR/etc/hyper/.hyper.js" ~

# Mac App Store application
mas install 1236045954 # Canary mail
mas install 926036361  # Lastpass
mas install 1289583905 # Pixelmator Pro
mas install 1303222628 # Paprika Recipe Manager 3
mas install 714196447  # Menubar Stats

# Safari Extensions
mas install 1481669779 # Evernote Web Clipper
mas install 957810159  # Raindrop.io for Safari
