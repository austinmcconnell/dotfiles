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

ZSH_COMPLETIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"

# Only try to generate completions if the directory exists
# (which means zsh was already set up)
if [[ -d "$ZSH_COMPLETIONS_DIR" ]]; then
    fnm completions --shell=zsh >"$ZSH_COMPLETIONS_DIR/_fnm"
fi

install-node-packages
