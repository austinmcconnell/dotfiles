#!/bin/zsh
#
# 20-extra.zsh - Load extra/custom configurations
#

# Hook for extra/custom stuff (e.g. settings for work laptop)
EXTRA_DIR="$HOME/.extra"
if [ -d "$EXTRA_DIR" ]; then
    for EXTRA_FILE in "$EXTRA_DIR"/.{env,alias,function,path}; do
        [ -f "$EXTRA_FILE" ] && . "$EXTRA_FILE"
    done
fi
