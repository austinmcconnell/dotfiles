#!/bin/bash

mkdir -p ~/.ssh/hosts.d
mkdir -p ~/.ssh/controlmasters
chmod 700 ~/.ssh ~/.ssh/hosts.d ~/.ssh/controlmasters

ln -sf ~/.dotfiles/etc/ssh/config ~/.ssh/config

if [ ! -f ~/.ssh/hosts.d/local.conf ]; then
    cp ~/.dotfiles/etc/ssh/hosts.d/example.conf.template ~/.ssh/hosts.d/local.conf
    chmod 600 ~/.ssh/hosts.d/local.conf
fi

echo "SSH configuration has been set up."
echo "Edit ~/.ssh/hosts.d/local.conf for machine-specific settings."
