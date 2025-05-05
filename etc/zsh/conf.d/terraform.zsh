#!/bin/zsh
#
# terraform.zsh - Terraform configurations and version management
#

##############################
# Environment Variables
##############################

# Set auto-install behavior for chtf
export CHTF_AUTO_INSTALL="yes" # yes/no/ask

# Initialize chtf if it exists
if [[ -f "/opt/homebrew/share/chtf/chtf.sh" ]]; then
  source "/opt/homebrew/share/chtf/chtf.sh"
fi
