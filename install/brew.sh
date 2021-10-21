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
brew install hadolint
brew install httpie
brew install jq
brew install kubernetes-cli
brew install mas
brew install --formula nano
brew install postgresql
brew install redis
brew install shellcheck
brew install shfmt
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

# Uninstall
brew uninstall svn # Only needed to install font-source-code-pro. Safe to delete after font installed.

# Create symlinks
ln -sfv "$DOTFILES_DIR/etc/hyper/.hyper.js" ~
ln -sfv "$DOTFILES_DIR/etc/misc/hadolint.yaml" ~/.config
