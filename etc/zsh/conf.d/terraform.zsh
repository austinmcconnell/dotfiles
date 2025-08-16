#!/bin/zsh
#
# terraform.zsh - Terraform configurations and version management
#

##############################
# Environment Variables
##############################

# Enable auto-install for tfenv (same behavior as chtf)
export TFENV_AUTO_INSTALL=true

# tfenv automatically detects .terraform-version files in current/parent directories
# and switches versions when running terraform commands
