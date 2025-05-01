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

# PostgreSQL
echo "Configuring PostgreSQL for XDG compliance"
mkdir -p "$XDG_CONFIG_HOME/pg"
mkdir -p "$XDG_DATA_HOME/pg"

if [[ -f "$HOME/.psql_history" ]]; then
    echo "Moving existing .psql_history file to XDG_DATA_HOME/pg/psql_history"
    mv "$HOME/.psql_history" "$XDG_DATA_HOME/pg/psql_history"
fi

if [[ -f "$HOME/.pgpass" ]]; then
    echo "Moving existing .pgpass file to XDG_CONFIG_HOME/pg/pgpass"
    mv "$HOME/.pgpass" "$XDG_CONFIG_HOME/pg/pgpass"
    chmod 0600 "$XDG_CONFIG_HOME/pg/pgpass"
fi

if [[ -f "$HOME/.psqlrc" ]]; then
    echo "Moving existing .psqlrc file to XDG_CONFIG_HOME/pg/psqlrc"
    mv "$HOME/.psqlrc" "$XDG_CONFIG_HOME/pg/psqlrc"
fi

# Terraform
echo "Configuring Terraform for XDG compliance"
mkdir -p "$XDG_CONFIG_HOME/terraform"
mkdir -p "$XDG_DATA_HOME/terraform/plugin-cache"

if [[ -f "$HOME/.terraformrc" ]]; then
    echo "Moving existing .terraformrc file to XDG_CONFIG_HOME/terraform/terraform.rc"
    mv "$HOME/.terraformrc" "$XDG_CONFIG_HOME/terraform/terraform.rc"
    # shellcheck disable=SC2016
    sed -i '' 's|$HOME/.terraform.d/plugin-cache|$XDG_DATA_HOME/terraform/plugin-cache|g' "$XDG_CONFIG_HOME/terraform/terraform.rc"
fi

if [[ -d "$HOME/.terraform.d" ]]; then
    echo "Moving existing .terraform.d directory contents to XDG_DATA_HOME/terraform"
    cp -r "$HOME/.terraform.d/"* "$XDG_DATA_HOME/terraform/"
    rm -rf "$HOME/.terraform.d"
fi

echo "XDG compliance configuration completed"
