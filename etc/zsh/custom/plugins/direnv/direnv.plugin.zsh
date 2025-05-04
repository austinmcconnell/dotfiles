#!/bin/zsh
#
# direnv.plugin.zsh - Directory environment manager
#

# Initialize direnv if it exists
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi
