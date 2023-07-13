#!/bin/bash

if is-executable nvm; then
    echo "**************************************************"
    echo "Configuring Node"
    echo "**************************************************"
else
    echo "**************************************************"
    echo "Installing Node"
    echo "**************************************************"
fi

NVM_DIR="$HOME/.nvm"

if [ -d "$NVM_DIR/.git" ]; then
    git --work-tree="$NVM_DIR" --git-dir="$NVM_DIR/.git" fetch --tags origin
    # shellcheck disable=SC2046
    git --work-tree="$NVM_DIR" --git-dir="$NVM_DIR/.git" checkout $(git --work-tree="$NVM_DIR" --git-dir="$NVM_DIR/.git" describe --abbrev=0 --tags --match "v[0-9]*" $(git --work-tree="$NVM_DIR" --git-dir="$NVM_DIR/.git" rev-list --tags --max-count=1))
else
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    # shellcheck disable=SC2046
    git --work-tree="$NVM_DIR" --git-dir="$NVM_DIR/.git" checkout $(git --work-tree="$NVM_DIR" --git-dir="$NVM_DIR/.git" describe --abbrev=0 --tags --match "v[0-9]*" $(git --work-tree="$NVM_DIR" --git-dir="$NVM_DIR/.git" rev-list --tags --max-count=1))
fi

# Due to nvm being cloned into the .nvm directory, need to clone first before creating symlinks
ln -sfv "$DOTFILES_DIR/etc/node/default-packages" "$NVM_DIR"
ln -sfv "$DOTFILES_DIR/etc/node/markdownlint" ~/.markdownlintrc
ln -sfv "$DOTFILES_DIR/etc/node/prettier.toml" ~/.config/prettier.toml

# shellcheck source-path=SCRIPTDIR/../../.nvm
. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default lts/*
