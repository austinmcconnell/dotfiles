#!/bin/zsh
#
# homebrew.zsh - Homebrew configuration and aliases
# This file is loaded on both macOS and Linux systems where Homebrew is available
#

##############################
# Environment Variables
##############################

# Limit how often Homebrew checks for updates
export HOMEBREW_API_AUTO_UPDATE_SECS=86400

# Don't upgrade casks that manage their own updates (VS Code, Docker, etc.)
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1

##############################
# Homebrew Aliases
##############################

# Show dependency tree for installed formulae
alias leaves="brew leaves | xargs brew deps --installed --for-each | sed \"s/^.*:/$(tput setaf 4)&$(tput sgr0)/\""
