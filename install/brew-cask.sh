#!/bin/sh

if ! is-executable brew; then
  echo "**************************************************"
  echo "Skipping Brew Cask Installs: Homebrew not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Installing Homebrew Casks"
  echo "**************************************************"
fi

brew tap homebrew/cask
brew tap homebrew/cask-fonts

# Install applications
brew install --cask atom
brew install --cask authy
brew install --cask betterzip
brew install --cask docker
brew install --cask dropbox
brew install --cask evernote
brew install --cask flux
brew install --cask font-source-code-pro
brew install --cask google-chrome
brew install --cask google-cloud-sdk
brew install --cask gpg-suite
brew install --cask hazel
brew install --cask iterm2
brew install --cask keepingyouawake
brew install --cask macdown
brew install --cask nextcloud
brew install --cask oversight
brew install --cask postico
brew install --cask pritunl
brew install --cask pycharm
brew install --cask slack
brew install --cask steam
brew install --cask spectacle
brew install --cask transmission
brew install --cask viscosity

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew install --cask qlcolorcode
brew install --cask qlstephen
brew install --cask qlmarkdown
brew install --cask quicklook-json
brew install --cask qlprettypatch
brew install --cask quicklook-csv
brew install --cask qlimagesize
brew install --cask webpquicklook
