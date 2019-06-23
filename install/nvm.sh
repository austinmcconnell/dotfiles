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

if [ ! -d "$HOME/.nvm" ] ; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
fi

mkdir $NVM_DIR

. "$NVM_DIR/nvm.sh"; nvm install --lts
. "$NVM_DIR/nvm.sh"; nvm alias default lts/*
