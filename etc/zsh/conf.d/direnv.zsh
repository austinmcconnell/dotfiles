#!/bin/zsh
#
# direnv.zsh - Directory environment manager
#

##############################
# Environment Variables
##############################

# Set XDG paths for direnv
export DIRENV_CONFIG="$XDG_CONFIG_HOME/direnv"

# Initialize direnv if it exists
if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi
