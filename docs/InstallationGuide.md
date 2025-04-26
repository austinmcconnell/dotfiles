# Installation Guide

This guide provides detailed instructions for installing and setting up the dotfiles repository on a
new system.

## Prerequisites

Before installing, ensure you have:

- macOS or a Debian-based Linux distribution
- Administrative access to your system
- Internet connection

## Installation Methods

### Method 1: Remote Installation (Recommended)

For a fresh macOS installation:

1. Install Xcode Command Line Tools:

   ```bash
   sudo softwareupdate -i -a
   xcode-select --install
   ```

2. Run the remote installation script:

   ```bash
   bash -c "`curl -fsSL https://raw.githubusercontent.com/austinmcconnell/dotfiles/master/remote-install.sh`"
   ```

This will automatically clone the repository to `~/.dotfiles` and start the installation process.

### Method 2: Manual Installation

If you prefer more control over the installation:

1. Clone the repository:

   ```bash
   git clone https://github.com/austinmcconnell/dotfiles.git ~/.dotfiles
   ```

2. Navigate to the dotfiles directory:

   ```bash
   cd ~/.dotfiles
   ```

3. Run the installation script:

   ```bash
   ./install.sh
   ```

## Installation Process

The installation script performs the following steps:

1. Updates the dotfiles repository if it already exists
2. Creates necessary directories:
   - `~/.config` (XDG config directory)
   - `~/.repositories` (for external repositories)
   - `~/.extra` (for machine-specific configurations)
3. Asks if this is a work computer to customize the setup
4. Installs and configures:
   - Git
   - Zsh (with antidote for plugin management)
   - Package managers (Homebrew on macOS, apt on Debian)
   - Applications (via Homebrew Cask on macOS)
   - Python (with pyenv)
   - Node.js
   - Vim (with vim-plug)
   - Utility scripts
   - SSH configuration
5. Creates a `.hushlogin` file to disable login messages
6. Runs tests to verify the installation

## Post-Installation

After installation completes, you should:

1. Configure macOS settings (if applicable):

   ```bash
   dotfiles mac-defaults
   ```

2. Set up your Dock with either personal or work configuration:

   ```bash
   dotfiles mac-dock-personal  # For personal setup
   # OR
   dotfiles mac-dock-work      # For work setup
   ```

3. Restart your terminal to apply all changes

## Customization

The installation creates a `~/.extra` directory where you can add custom configurations:

- `~/.extra/.env`: Environment variables
- `~/.extra/aliases.sh`: Custom aliases
- `~/.extra/functions.sh`: Custom functions
- `~/.extra/path.sh`: Custom PATH additions

These files are automatically sourced if they exist.

## Troubleshooting

If you encounter issues during installation:

1. Check the output for error messages
2. Verify that you have the necessary permissions
3. Ensure your internet connection is working
4. Run `dotfiles test` to check for configuration issues
5. Check system logs for more detailed error information

For persistent issues, you can:

- Review the installation scripts in the `install/` directory
- Check for conflicting configurations in your home directory
- Try running individual installation scripts manually
