#!/bin/zsh
#
# fnm.plugin.zsh - Fast Node Manager configuration
#

# Initialize fnm if it exists
if [[ -d "$FNM_PATH" ]]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
fi
