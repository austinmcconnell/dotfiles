#!/bin/bash
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

sudo apt-get update

# Install packages not available or practical via Homebrew
sudo apt install -y bc
sudo apt install -y fonts-firacode
sudo apt install -y less
