#!/bin/bash

echo "**************************************************"
echo "Configuring wget"
echo "**************************************************"

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

echo "wget configured to use XDG directories"
