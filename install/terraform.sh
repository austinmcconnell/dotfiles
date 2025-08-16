#!/bin/bash

if is-executable terraform; then
    echo "**************************************************"
    echo "Configuring Terraform"
    echo "**************************************************"
else
    echo "**************************************************"
    echo "Terraform not found - install via tfenv"
    echo "**************************************************"
    echo "Run: tfenv install latest"
    return
fi

# Create XDG-compliant terraform directories
mkdir -p "$XDG_CONFIG_HOME/terraform"
mkdir -p "$XDG_DATA_HOME/terraform/plugin-cache"

# Link terraform configuration file to XDG location
ln -sfv "$DOTFILES_DIR/etc/terraform/terraform.rc" "$XDG_CONFIG_HOME/terraform/terraform.rc"
