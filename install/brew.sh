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
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
brew install --formula blueutil
brew install --formula chtf
brew install --formula coreutils
brew install --formula dive
# brew install --formula dockutil
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
brew install --formula terraform
brew install --formula tree
brew install --formula unar
brew install --formula wget
brew install --formula wifi-password
brew install --formula yamllint
brew install --formula zlib # Used for compiling (e.g. pyenv building python versions from source)

# Install cloud cli tools
brew install --formula awscli

# Install applications
brew install --cask alfred
brew install --cask backuploupe
brew install --cask bartender
brew install --cask docker
brew install --cask evernote
brew install --cask flux
brew install --cask firefox
brew install --cask font-fira-code
brew install --cask gpg-suite
brew install --cask hazel
brew install --cask hpedrorodrigues/tools/dockutil
brew install --cask iterm2
brew install --cask keepingyouawake
brew install --cask monitorcontrol
brew install --cask multipass
brew install --cask obsidian
brew install --cask oversight
brew install --cask postico
brew install --cask rectangle
brew install --cask silicon
brew install --cask slack
brew install --cask spotify
brew install --cask sublime-text
brew install --cask tableplus
brew install --cask the-unarchiver
brew install --cask vagrant
brew install --cask viscosity
brew install --cask visual-studio-code
brew install --cask zoom

# Create symlinks
ln -sfv "$DOTFILES_DIR/etc/misc/hadolint.yaml" ~/.config
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Package Control.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Preferences.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Python.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
