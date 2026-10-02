#!/bin/bash

set -euo pipefail

# ---------------------------------------------------------------------------
# Ghostty terminal emulator
#
# Installs Ghostty (macOS cask) and symlinks its config from the repo into the
# XDG config location Ghostty reads natively ($XDG_CONFIG_HOME/ghostty/config).
#
# Trial setup: this is a candidate iTerm2 replacement. The config in
# etc/ghostty/config is a faithful translation of the iTerm2 "personal" profile.
# ---------------------------------------------------------------------------

source "${DOTFILES_DIR}/install/utils.sh"

print_section_header "Configuring Ghostty"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

if is-macos; then
    install_if_needed ghostty cask
elif is-debian; then
    echo "Ghostty is not distributed as a Debian package here; skipping install."
    echo "See https://ghostty.org/docs/install for Linux options."
else
    echo "Skipping Ghostty installation: Unidentified OS"
    return
fi

# Symlink config into the location Ghostty reads natively.
mkdir -p "${XDG_CONFIG_HOME}/ghostty/themes"
ln -sfv "${DOTFILES_DIR}/etc/ghostty/config" "${XDG_CONFIG_HOME}/ghostty/config"

# Vendored named themes (referred to by name from the config), mirroring the
# dircolors convention of shipping named colorscheme files.
ln -sfv "${DOTFILES_DIR}/etc/ghostty/themes/everforest-dark-medium" \
    "${XDG_CONFIG_HOME}/ghostty/themes/everforest-dark-medium"

echo "Ghostty configuration complete"
