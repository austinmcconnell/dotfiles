#!/bin/zsh
#
# 10-antidote.zsh - Load and configure antidote plugin manager
#

# Load antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Generate static plugin file if needed
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
fi

# Source the static plugins file
source ${zsh_plugins}.zsh
