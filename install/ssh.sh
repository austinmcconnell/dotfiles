#!/bin/bash

source "$DOTFILES_DIR/install/utils.sh"

set -euo pipefail

mkdir -p ~/.ssh/hosts.d
mkdir -p ~/.ssh/controlmasters
chmod 700 ~/.ssh ~/.ssh/hosts.d ~/.ssh/controlmasters

link_and_verify "$DOTFILES_DIR/etc/ssh/config" "$HOME/.ssh/config" || return 1

if [ ! -f ~/.ssh/hosts.d/local.conf ]; then
    cp ~/.dotfiles/etc/ssh/hosts.d/example.conf.template ~/.ssh/hosts.d/local.conf
    chmod 600 ~/.ssh/hosts.d/local.conf
fi

echo "SSH configuration has been set up."
echo "Edit ~/.ssh/hosts.d/local.conf for machine-specific settings."
