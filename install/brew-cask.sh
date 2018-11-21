#!/bin/sh

if ! is-executable brew; then
  echo "Skipping Brew Cask Installs: Homebrew not installed"
  return
else
  echo "**************************************************"
  echo "Installing Homebrew Casks"
  echo "**************************************************"
fi

brew tap caskroom/cask
brew tap caskroom/fonts

# Install applications
brew cask install atom
brew cask install authy
brew cask install betterzip
brew cask install docker
brew cask install dropbox
brew cask install evernote
brew cask install flux
brew cask install font-source-code-pro
brew cask install google-chrome
brew cask install hazel
brew cask install iterm2
brew cask install keepingyouawake
brew cask install macdown
brew cask install nextcloud
brew cask install oversight
brew cask install postico
brew cask install slack
brew cask install steam
brew cask install spectacle
brew cask install transmission
brew cask install viscosity

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlprettypatch
brew cask install quicklook-csv
brew cask install qlimagesize
brew cask install webpquicklook
