#!/bin/zsh
#
# chtf.plugin.zsh - Terraform version manager
#

# Set auto-install behavior
CHTF_AUTO_INSTALL="yes" # yes/no/ask

# Initialize chtf if it exists
if [[ -f "/opt/homebrew/share/chtf/chtf.sh" ]]; then
  source "/opt/homebrew/share/chtf/chtf.sh"
fi
