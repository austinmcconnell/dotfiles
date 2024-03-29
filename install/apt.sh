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

# Add Repositories
sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Install packages
sudo apt install -y fonts-firacode
sudo apt install -y jq
sudo apt install -y less
sudo apt install -y shellcheck
sudo apt install -y tree
sudo apt install -y yamllint

# Install snaps
sudo snap install shfmt

# Create symlinks
ln -sfv "$DOTFILES_DIR/etc/misc/shellcheckrc" "$XDG_CONFIG_HOME/shellcheckrc"
