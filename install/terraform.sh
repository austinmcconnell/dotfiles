#!/bin/bash

if is-executable tfenv; then
    echo "**************************************************"
    echo "Configuring Terraform"
    echo "**************************************************"
else
    echo "**************************************************"
    echo "Installing Terraform (via tfenv)"
    echo "**************************************************"
    brew install tfenv
fi

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

# Install Terraform tooling
if ! is-executable terraform-docs; then
    echo "Installing terraform-docs..."
    brew install terraform-docs
fi

if ! is-executable tfsec; then
    echo "Installing tfsec..."
    brew install tfsec
fi

if ! is-executable checkov; then
    echo "Installing checkov..."
    brew install checkov
fi
