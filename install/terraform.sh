#!/bin/bash

if ! is-executable tfenv; then
    echo "**************************************************"
    echo "Skipping Terraform configuration: tfenv not found"
    echo "**************************************************"
    return
fi

echo "**************************************************"
echo "Configuring Terraform"
echo "**************************************************"

# Create XDG-compliant terraform directories
mkdir -p "$XDG_CONFIG_HOME/terraform"
mkdir -p "$XDG_DATA_HOME/terraform/plugin-cache"

# Link terraform configuration file to XDG location
ln -sfv "$DOTFILES_DIR/etc/terraform/terraform.rc" "$XDG_CONFIG_HOME/terraform/terraform.rc"

# Install latest Terraform version if not already installed
if is-executable tfenv && ! is-executable terraform; then
    echo "Installing latest Terraform version..."
    tfenv install latest
    tfenv use latest
fi

# terraform-docs, tfsec, checkov installed via terraform.Brewfile
