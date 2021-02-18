#!/bin/sh
if is-executable brew; then
  echo "**************************************************"
  echo "Configuring Homebrew"
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
brew install circleci
brew install coreutils
brew install diff-so-fancy
brew install docker
brew install dockutil
brew install git
brew install git-crypt
brew install git-extras
brew install grep
brew install heroku
brew install httpie
brew install hub
brew install jq
brew install kubectx
brew install kubernetes-helm
brew install nano
brew install node
brew install postgresql
brew install psgrep
brew install redis
brew install ruby
brew install shellcheck
brew install ssh-copy-id
brew install stern
brew install the_silver_searcher
brew install terraform
brew install tree
brew install unar
brew install wget
brew install wifi-password

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
