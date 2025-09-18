#!/bin/bash

# Source the utilities script for helper functions
source "$DOTFILES_DIR/install/utils.sh"

# Install casks
install_if_needed "makemkv" "cask"
install_if_needed "subler" "cask"
install_if_needed "sublercli" "cask"

# Install formulas
install_if_needed "ffmpeg" "formula"
install_if_needed "mkvtoolnix" "formula"
install_if_needed "mediainfo" "formula"
install_if_needed "atomicparsley" "formula"
