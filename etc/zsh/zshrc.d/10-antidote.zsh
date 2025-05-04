#!/bin/zsh
#
# 10-antidote.zsh - Load and configure antidote plugin manager
#

# Load antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Get paths from zstyle configuration
local bundle_file static_file
zstyle -s ':antidote:bundle' file bundle_file
zstyle -s ':antidote:static' file static_file

# Generate static plugin file if needed
if [[ ! ${static_file} -nt ${bundle_file} ]]; then
  antidote bundle <${bundle_file} >${static_file}
fi

# Source the static plugins file
source ${static_file}
