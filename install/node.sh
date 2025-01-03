#!/bin/bash

if is-executable fnm; then
    echo "**************************************************"
    echo "Configuring Node"
    echo "**************************************************"
else
    echo "**************************************************"
    echo "Installing Node"
    echo "**************************************************"
fi

brew install --formula fnm

mkdir -p "$FNM_PATH"

# FNM doesn't support installing default packages
# https://github.com/Schniz/fnm/issues/139
ln -sfv "$DOTFILES_DIR/etc/node/default-packages" "$FNM_PATH"
ln -sfv "$DOTFILES_DIR/etc/node/markdownlint" ~/.markdownlintrc
ln -sfv "$DOTFILES_DIR/etc/node/prettier.toml" "$XDG_CONFIG_HOME/prettier.toml"

fnm install --lts
fnm default lts-latest

install-node-packages
