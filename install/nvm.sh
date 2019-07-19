#!/bin/sh

if ! is-executable brew; then
  echo "**************************************************"
  echo "Skipping NVM Installs: Homebrew not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Installing NVM packages"
  echo "**************************************************"
fi

NVM_DIR="$HOME/.nvm"

ln -sfv "$DOTFILES_DIR/etc/node/markdownlint" ~/.markdownlintrc

if [ ! -d "$HOME/.nvm" ] ; then
    mkdir "$NVM_DIR"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
fi

. "$NVM_DIR/nvm.sh"; nvm install --lts
. "$NVM_DIR/nvm.sh"; nvm alias default lts/*
