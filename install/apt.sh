#!/bin/sh
if is-debian && is-executable apt; then
    echo "**************************************************"
    echo "Configuring services with apt"
    echo "**************************************************"
else
    echo "**************************************************"
    echo "Skipping apt packages installation: Not linux"
    echo "**************************************************"
    return
fi

sudo apt install fonts-firacode
sudo apt install jq
sudo apt install kubernetes
sudo apt install shellcheck
sudo apt install tree
sudo apt install yamllint

sudo snap install shfmt
