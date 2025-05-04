#!/bin/zsh
#
# 60-fnm.zsh - Fast Node Manager configuration
#

# fnm
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "`fnm env --use-on-cd --version-file-strategy=recursive`"
fi
