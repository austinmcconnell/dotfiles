# Getting Started with Dotfiles

## Philosophy

This dotfiles repository is built on several core principles:

1. **Automation First**: Minimize manual setup steps when configuring a new system
2. **Modularity**: Components are organized into logical modules that can be enabled or disabled
3. **Cross-Platform**: Support for both macOS and Debian-based Linux systems
4. **Customization**: Easy to adapt for personal or work environments
5. **Maintainability**: Clear structure and documentation to make updates straightforward

## Repository Structure

The repository is organized into several key directories:

- **bin/**: Executable scripts and utilities that are added to your PATH
- **etc/**: Configuration files for various applications and tools
- **install/**: Installation scripts for different components of the system
- **macos/**: macOS-specific configurations and settings
- **scripts/**: Utility scripts for various tasks
- **tests/**: Test suite to ensure everything works correctly
- **docs/**: Documentation for the project (you are here!)

## Core Components

### Installation System

The main `install.sh` script coordinates the installation process by:

1. Setting up necessary directories
2. Determining if this is a work or personal computer
3. Running individual installation scripts for different components
4. Configuring the shell environment

### The `dotfiles` Command

The `dotfiles` command provides a unified interface for managing your dotfiles:

- `dotfiles update`: Update packages and package managers
- `dotfiles edit`: Open the dotfiles in your preferred editor
- `dotfiles mac-defaults`: Apply macOS system defaults
- `dotfiles mac-dock-personal` or `dotfiles mac-dock-work`: Configure the macOS Dock
- `dotfiles clean`: Clean up package manager caches
- `dotfiles test`: Run the test suite

### Configuration Files

Configuration files in the `etc/` directory are symlinked to their appropriate locations in your home
directory. This allows you to:

1. Keep all configurations in one place
2. Track changes with git
3. Easily sync between multiple machines

## Getting Started

### New Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/austinmcconnell/dotfiles.git ~/.dotfiles
   ```

2. Run the installation script:

   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

3. Answer the prompt about whether this is a work computer

4. Configure macOS settings (if applicable):

   ```bash
   dotfiles mac-defaults
   dotfiles mac-dock-personal  # or mac-dock-work for work setup
   ```

### Customization

To customize your setup:

1. Create or edit files in the `~/.extra` directory for machine-specific configurations
2. Modify the appropriate configuration files in the `etc/` directory
3. Run `dotfiles update` to apply changes

### Work vs. Personal Setup

The dotfiles repository distinguishes between work and personal environments:

- Work environments may have different package selections
- Dock configurations are separated into work and personal layouts
- Additional work-specific configurations can be added to `~/.extra`

## Advanced Usage

### Adding New Tools

To add configuration for a new tool:

1. Create a configuration file in `etc/`
2. Add an installation script in `install/` if needed
3. Update the main `install.sh` to include your new script

### Troubleshooting

If you encounter issues:

1. Run `dotfiles test` to verify that everything is working correctly
2. Check the output of installation scripts for errors
3. Verify that symlinks are correctly established
4. Consult the specific documentation for the component that's causing issues
