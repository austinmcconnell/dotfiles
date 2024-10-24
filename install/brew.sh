#!/bin/bash
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

mkdir -p "$XDG_CONFIG_HOME/bat"
mkdir -p "$XDG_CONFIG_HOME/fd"
mkdir -p "$XDG_CONFIG_HOME/httpie"

ln -sfv "$DOTFILES_DIR/etc/misc/hadolint.yaml" "$XDG_CONFIG_HOME"
ln -sfv "$DOTFILES_DIR/etc/misc/shellcheckrc" "$XDG_CONFIG_HOME/shellcheckrc"
ln -sfv "$DOTFILES_DIR/etc/fd/ignore" "$XDG_CONFIG_HOME/fd/ignore"
ln -sfv "$DOTFILES_DIR/etc/httpie/config.json" "$XDG_CONFIG_HOME/httpie/config.json"
ln -sfv "$DOTFILES_DIR/etc/bat/config" "$XDG_CONFIG_HOME/bat/config"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Package Control.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Preferences.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/Python.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
ln -sfv "$DOTFILES_DIR/etc/sublime-text/SublimeLinter.sublime-settings" "$HOME/Library/Application Support/Sublime Text/Packages/User"
if is-macos; then
    ln -sfv "$DOTFILES_DIR/etc/sublime-text/Default (OSX).sublime-keymap" "$HOME/Library/Application Support/Sublime Text/Packages/User"
fi

# Add taps
brew tap derailed/k9s
brew tap heroku/brew
brew tap Yleisradio/terraforms

# Install packages
brew install --formula autoenv
brew install --formula bash
brew install --formula bat
brew install --formula blueutil
brew install --formula ccache
brew install --formula chtf
brew install --formula coreutils
brew install --formula dive
# brew install --formula dockutil
brew install --formula fd
brew install --formula findutils
brew install --formula fzf
brew install --formula git
brew install --formula git-delta
brew install --formula go
brew install --formula grep
brew install --formula hadolint
brew install --formula helm
brew install --formula httpie
brew install --formula jq
brew install --formula k9s
brew install --formula kubernetes-cli
brew install --formula mas
brew install --formula nano
brew install --formula openssl # Used for compiling (e.g. pyenv building python versions from source)
brew install --formula shellcheck
brew install --formula shfmt
brew install --formula ssh-copy-id
brew install --formula terraform
brew install --formula tree
brew install --formula trivy
brew install --formula unar
brew install --formula wget
brew install --formula wifi-password
brew install --formula yamllint
brew install --formula zlib # Used for compiling (e.g. pyenv building python versions from source)
brew install --formula zunit-zsh/zunit/zunit

# Install cloud cli tools
brew install --formula awscli

# Install applications
brew install --cask alfred
brew install --cask backuploupe
brew install --cask bartender
brew install --cask bluesnooze
brew install --cask calibre
brew install --cask docker
brew install --cask evernote
brew install --cask flux
brew install --cask firefox
brew install --cask gpg-suite
brew install --cask hazel
brew install --cask hpedrorodrigues/tools/dockutil
brew install --cask iterm2
brew install --cask keepingyouawake
brew install --cask monitorcontrol
brew install --cask multipass
brew install --cask obsidian
brew install --cask openlens
brew install --cask oversight
brew install --cask postico
brew install --cask postman
brew install --cask rectangle
brew install --cask silicon
brew install --cask slack
brew install --cask spotify
brew install --cask sublime-text
brew install --cask tableplus
brew install --cask the-unarchiver
brew install --cask vagrant
brew install --cask via
brew install --cask viscosity
brew install --cask visual-studio-code
brew install --cask zoom

# Install fonts
brew install --cask font-fira-code
brew install --cask font-meslo-lg-nerd-font
brew install --cask font-fira-code-nerd-font
brew install --cask font-hack-nerd-font
brew install --cask font-inconsolata-nerd-font
brew install --cask font-sauce-code-pro-nerd-font

# TLS/SSL Setup local Certificate Authority and add to the system and firefox trust store
brew install --formula mkcert
brew install --formula nss
mkcert -install

# Add helm charts repository
helm repo add stable https://charts.helm.sh/stable
