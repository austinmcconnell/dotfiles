# Customization Guide

This guide explains how to customize your dotfiles setup to match your specific needs and
preferences.

## Overview

The dotfiles repository is designed to be highly customizable, allowing you to:

- Adapt it for different environments (personal, work)
- Add or remove tools and configurations
- Extend functionality with custom scripts
- Maintain machine-specific settings

## The `.extra` Directory

The primary way to customize your setup is through the `~/.extra` directory, which is created during
installation. This directory contains files that are not tracked by git, allowing you to maintain
machine-specific configurations.

### Available Customization Files

- `~/.extra/.env`: Environment variables
- `~/.extra/aliases.sh`: Custom shell aliases
- `~/.extra/functions.sh`: Custom shell functions
- `~/.extra/path.sh`: Custom PATH additions

These files are automatically sourced if they exist, allowing you to override or extend the default
configurations.

### Example: Adding Custom Environment Variables

```bash
# ~/.extra/.env
export EDITOR="vim"
export VISUAL="code"
export CUSTOM_API_KEY="your-api-key"
```

### Example: Adding Custom Aliases

```bash
# ~/.extra/aliases.sh
alias projects="cd ~/Projects"
alias notes="cd ~/Notes && code ."
```

### Example: Adding Custom Functions

```bash
# ~/.extra/functions.sh
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

function weather() {
  curl -s "wttr.in/$1"
}
```

### Example: Extending PATH

```bash
# ~/.extra/path.sh
export PATH="$HOME/custom-scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
```

## Work vs. Personal Configuration

The dotfiles repository distinguishes between work and personal environments through the
`IS_WORK_COMPUTER` environment variable, which is set during installation.

### Checking Work Status in Scripts

You can use the `is-work` utility function in your scripts to conditionally execute code based on
whether it's a work or personal computer:

```bash
if is-work; then
    # Work-specific configuration
else
    # Personal configuration
fi
```

### Work-Specific Customizations

For work environments, you might want to:

- Configure different Git user information
- Install work-specific tools and applications
- Set up VPN configurations
- Configure proxy settings

## Adding New Tools

### Adding a New Configuration File

To add configuration for a new tool:

1. Create a configuration file in the `etc/` directory:

   ```bash
   touch ~/.dotfiles/etc/toolname/config
   ```

2. Add an installation script in the `install/` directory:

   ```bash
   touch ~/.dotfiles/install/toolname.sh
   chmod +x ~/.dotfiles/install/toolname.sh
   ```

3. Update the main `install.sh` to include your new script:

   ```bash
   echo '. "$DOTFILES_DIR/install/toolname.sh"' >> ~/.dotfiles/install.sh
   ```

### Example: Adding a New Tool Configuration

Here's an example of adding configuration for a hypothetical tool called "devtool":

1. Create the configuration file:

   ```bash
   mkdir -p ~/.dotfiles/etc/devtool
   touch ~/.dotfiles/etc/devtool/config.yml
   ```

2. Create the installation script:

   ```bash
   # ~/.dotfiles/install/devtool.sh
   #!/usr/bin/env bash

   if ! is-executable devtool; then
       echo "Installing devtool..."
       if is-macos; then
           brew install devtool
       elif is-debian; then
           sudo apt install -y devtool
       fi
   fi

   # Link configuration file
   mkdir -p ~/.config/devtool
   ln -sf "$DOTFILES_DIR/etc/devtool/config.yml" ~/.config/devtool/config.yml
   ```

3. Make the script executable:

   ```bash
   chmod +x ~/.dotfiles/install/devtool.sh
   ```

4. Add it to the main installation script.

## Customizing macOS Settings

### Dock Configuration

You can customize the Dock by modifying the appropriate Dock script:

- For personal setups: `~/.dotfiles/macos/dock-personal.sh`
- For work setups: `~/.dotfiles/macos/dock-work.sh`

### System Defaults

To customize macOS system defaults, modify the `~/.dotfiles/macos/defaults.sh` file or create a new
file with the pattern `defaults-*.sh` in the `macos` directory.

## Extending the `dotfiles` Command

You can add new subcommands to the `dotfiles` command by adding new functions to the
`~/.dotfiles/bin/dotfiles` script:

```bash
sub_new_command() {
    echo "Executing new command..."
    # Your command logic here
}
```

Remember to update the help message to include your new command:

```bash
sub_help() {
    # ... existing help content ...
    echo "   new-command        Description of your new command"
}
```

## Best Practices

1. **Test Changes**: Always test your changes before committing them
2. **Document Customizations**: Add comments to your custom scripts and configurations
3. **Keep It Modular**: Create separate files for different functionalities
4. **Use Version Control**: Commit changes to your dotfiles repository regularly
5. **Backup Before Changes**: Always backup important configurations before making significant
   changes
