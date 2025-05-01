#!/bin/bash

echo "**************************************************"
echo "Configuring XDG compliance for CLI tools"
echo "**************************************************"

# Less
echo "Configuring Less for XDG compliance"
mkdir -p "$XDG_CONFIG_HOME/less"
mkdir -p "$XDG_CACHE_HOME/less"
if [[ -f "$HOME/.lesshst" ]]; then
    echo "Moving existing .lesshst file to XDG_CACHE_HOME/less/history"
    mv "$HOME/.lesshst" "$XDG_CACHE_HOME/less/history"
fi

# Wget
echo "Configuring Wget for XDG compliance"
mkdir -p "$XDG_CONFIG_HOME/wget"
mkdir -p "$XDG_DATA_HOME/wget"

cat >"$XDG_CONFIG_HOME/wget/wgetrc" <<EOF
# Wget configuration file
# Store HSTS information in XDG_DATA_HOME
hsts-file = $XDG_DATA_HOME/wget/wget-hsts
EOF

if [[ -f "$HOME/.wget-hsts" ]]; then
    echo "Moving existing .wget-hsts file to XDG_DATA_HOME/wget"
    mv "$HOME/.wget-hsts" "$XDG_DATA_HOME/wget/wget-hsts"
fi

echo "XDG compliance configuration completed"
