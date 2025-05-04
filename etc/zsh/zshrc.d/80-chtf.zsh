#!/bin/zsh
#
# 80-chtf.zsh - Terraform version manager
#

# chtf
CHTF_AUTO_INSTALL="yes" # yes/no/ask
if [[ -f "/opt/homebrew/share/chtf/chtf.sh" ]]; then
    source "/opt/homebrew/share/chtf/chtf.sh"
fi
