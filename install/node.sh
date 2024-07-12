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

# install fnm
curl -fsSL https://fnm.vercel.app/install | bash

ln -sfv "$DOTFILES_DIR/etc/node/default-packages" "$FNM_PATH"
ln -sfv "$DOTFILES_DIR/etc/node/markdownlint" ~/.markdownlintrc
ln -sfv "$DOTFILES_DIR/etc/node/prettier.toml" "$XDG_CONFIG_HOME/prettier.toml"

fnm install --lts
fnm default lts-latest
