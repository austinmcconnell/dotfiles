#!/bin/bash

# Load media pipeline configuration
[[ -f "$DOTFILES_DIR/etc/media/media-pipeline.conf" ]] && . "$DOTFILES_DIR/etc/media/media-pipeline.conf"

# Create directories from config
mkdir -p "${RIPPED_DIR:-$HOME/movies/ripped}" \
    "${REMUXED_DIR:-$HOME/movies/remuxed}" \
    "${TRANSCODED_DIR:-$HOME/movies/transcoded}" \
    "${TAGGED_DIR:-$HOME/movies/tagged}" \
    "${FINISHED_DIR:-$HOME/movies/finished}"

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
