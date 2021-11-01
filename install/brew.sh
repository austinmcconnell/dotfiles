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
brew install --formula autoenv
brew install --formula bash
brew install --formula bats-core
brew install --formula chtf
brew install --formula coreutils
brew install --formula dive
brew install --formula dockutil
brew install --formula git
brew install --formula grep
brew install --formula hadolint
brew install --formula httpie
brew install --formula jq
brew install --formula kubernetes-cli
brew install --formula mas
brew install --formula nano
brew install --formula openssl # Used for compiling (e.g. pyenv building python versions from source)
brew install --formula shellcheck
brew install --formula shfmt
brew install --formula ssh-copy-id
brew install --formula svn
brew install --formula terraform
brew install --formula tree
brew install --formula unar
brew install --formula wget
brew install --formula wifi-password
brew install --formula yamllint
brew install --formula zlib # Used for compiling (e.g. pyenv building python versions from source)

# Install applications
brew install --cask alfred
brew install --cask atom
brew install --cask betterzip
brew install --cask docker
brew install --cask dozer
brew install --cask dropbox
brew install --cask evernote
brew install --cask flux
brew install --cask font-source-code-pro
brew install --cask font-fira-code
brew install --cask google-chrome
brew install --cask google-cloud-sdk
brew install --cask gpg-suite
brew install --cask hazel
brew install --cask hyper
brew install --cask iterm2
brew install --cask keepingyouawake
brew install --cask keybase
brew install --cask macdown
brew install --cask monitorcontrol
brew install --cask multipass
brew install --cask oversight
brew install --cask postico
brew install --cask slack
brew install --cask spectacle
brew install --cask spotify
brew install --cask steam
brew install --cask tableplus
brew install --cask vagrant
brew install --cask viscosity
brew install --cask visual-studio-code
brew install --cask zoom

# Uninstall
brew uninstall svn # Only needed to install font-source-code-pro. Safe to delete after font installed.

# Create symlinks
ln -sfv "$DOTFILES_DIR/etc/hyper/.hyper.js" ~
ln -sfv "$DOTFILES_DIR/etc/misc/hadolint.yaml" ~/.config
