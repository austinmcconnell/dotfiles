#!/bin/sh

if ! is-executable nvm; then
  echo "**************************************************"
  echo "Skipping NVM Configuration: nvm not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Installing NVM packages"
  echo "**************************************************"
fi

NVM_DIR="$HOME/.nvm"

ln -sfv "$DOTFILES_DIR/etc/node/markdownlint" ~/.markdownlintrc
ln -sfv "$DOTFILES_DIR/etc/node/default-packages" "$NVM_DIR"

. "$NVM_DIR/nvm.sh"; nvm install --lts
. "$NVM_DIR/nvm.sh"; nvm alias default lts/*
