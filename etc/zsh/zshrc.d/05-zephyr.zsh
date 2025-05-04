#!/bin/zsh
#
# 05-zephyr.zsh - Initialize Zephyr framework
#

# Define which Zephyr plugins to load (these will be loaded by antidote)
zephyr_plugins=(
  color
  directory
  environment
  history
  homebrew
  prompt
  utility
  zfunctions
)
zstyle ':zephyr:load' plugins $zephyr_plugins

# Set Zephyr home directory - hardcoded for performance
export ZEPHYR_HOME=${ANTIDOTE_HOME:-$HOME/Library/Caches/antidote}/mattmc3/zephyr
