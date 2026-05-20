#!/bin/bash

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_section_header "Configuring sops + age"

# Install age and sops if not present
if ! is-executable age; then
    brew install age
fi

if ! is-executable sops; then
    brew install sops
fi

# XDG-compliant age key directory
mkdir -p "$XDG_CONFIG_HOME/sops/age"

# Symlink .sops.yaml to dotfiles root for auto-discovery
ln -sfv "$DOTFILES_DIR/etc/sops/sops.yaml" "$DOTFILES_DIR/.sops.yaml"

# Generate age key if not present
if [ ! -f "$XDG_CONFIG_HOME/sops/age/keys.txt" ]; then
    echo "Generating new age key..."
    age-keygen -o "$XDG_CONFIG_HOME/sops/age/keys.txt"
    chmod 600 "$XDG_CONFIG_HOME/sops/age/keys.txt"
    PUBLIC_KEY="$(grep 'public key' "$XDG_CONFIG_HOME/sops/age/keys.txt" | cut -d: -f2 | tr -d ' ')"
    sed -i "s/AGE_PUBLIC_KEY_PLACEHOLDER/$PUBLIC_KEY/" "$DOTFILES_DIR/etc/sops/sops.yaml"
    echo ""
    echo "⚠️  Back up $XDG_CONFIG_HOME/sops/age/keys.txt to a password manager!"
    echo "   Public key: $PUBLIC_KEY"
else
    echo "Age key already exists at $XDG_CONFIG_HOME/sops/age/keys.txt"
fi

# Create encrypted secrets directory
mkdir -p "$DOTFILES_DIR/etc/secrets"
