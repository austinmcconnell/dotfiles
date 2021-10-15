#!/bin/sh
if is-executable brew; then
  echo "**************************************************"
  echo "Installing macOS services"
  echo "**************************************************"
else
  if is-macos; then
    echo "**************************************************"
    echo "Installing Homebrew"
    echo "**************************************************"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "**************************************************"
    echo "Skipping Homebrew installation: Not macOS"
    echo "**************************************************"
    return
  fi
fi

# Add taps
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap heroku/brew
brew tap Yleisradio/terraforms

# Install packages
brew install autoenv
brew install bash
brew install bats
brew install chtf
brew install coreutils
brew install dockutil
brew install git
brew install git-crypt
brew install git-extras
brew install grep
brew install httpie
brew install jq
brew install kubernetes-cli
brew install nano
brew install postgresql
brew install redis
brew install shellcheck
brew install ssh-copy-id
brew install svn
brew install terraform
brew install tree
brew install unar
brew install wget
brew install wifi-password
brew install yamllint

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew install --cask qlcolorcode
brew install --cask qlstephen
brew install --cask qlmarkdown
brew install --cask quicklook-json
brew install --cask qlprettypatch
brew install --cask quicklook-csv
brew install --cask qlimagesize
brew install --cask webpquicklook
