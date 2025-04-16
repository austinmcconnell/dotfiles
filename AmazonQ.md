# Amazon Q Setup

This document describes how Amazon Q is set up in this dotfiles repository.

## Installation

Amazon Q is installed via the dedicated installation script:

```bash
./install/amazon-q.sh
```

This script:

1. Installs the Amazon Q cask using Homebrew
2. Creates necessary configuration directories
3. Links configuration files from the dotfiles repository
4. Installs Amazon Q integrations (like SSH)

## Configuration Files

The configuration files are stored in:

- `etc/amazon-q/settings.json` - Application settings
- `etc/amazon-q/rules.json` - Rules for code generation and execution

## Manual Steps

After installation, you may need to:

1. Launch Amazon Q and sign in with your AWS account
2. Configure any additional integrations through the UI
3. Customize settings as needed

## Troubleshooting

If you encounter issues:

1. Check that the configuration directories exist
2. Verify that the symbolic links are correctly established
3. Restart Amazon Q after making configuration changes
