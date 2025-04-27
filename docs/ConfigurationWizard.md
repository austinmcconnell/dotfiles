# Configuration Wizard

The dotfiles repository includes an interactive configuration wizard that guides you through the setup
process, helping you customize your environment to match your needs.

## Overview

The configuration wizard provides a step-by-step interface to:

1. Select a profile that matches your use case
2. Customize which modules are enabled
3. Configure personal preferences
4. Set up your development environment

## Running the Wizard

The wizard runs automatically during the initial installation if no configuration file exists:

```bash
./install.sh
```

You can also run the wizard manually to reconfigure your setup:

```bash
. ./install/wizard.sh
run_wizard
```

## Wizard Steps

### Step 1: Profile Selection

Choose from predefined profiles:

- **default**: Standard configuration for personal use
- **work**: Configuration optimized for work environment
- **minimal**: Lightweight configuration for servers or minimal setups

Each profile comes with a different set of enabled modules and components.

### Step 2: Module Customization

Review and customize which modules are enabled:

- **shell**: Zsh configuration with plugins and themes
- **package_managers**: System package managers (Homebrew, APT)
- **development**: Programming languages and development tools
- **system**: OS-specific settings and configurations
- **applications**: Desktop applications and utilities
- **cloud**: Cloud service provider tools and configurations
- **ai**: AI assistant configurations and integrations

### Step 3: Personal Information

Configure personal settings:

- Git user name and email
- Preferred text editor
- Other personal preferences

### Step 4: Additional Options

Set preferences for:

- Terminal theme (dark/light)
- Shell prompt style
- Programming language versions
- Other customization options

### Step 5: Review and Confirm

Review your selections before applying them:

- Selected profile
- Enabled modules
- Personal information
- Additional options

## Configuration Files

The wizard generates two main configuration files:

1. `~/.extra/config.yaml`: Contains your profile selection and module overrides
2. `~/.extra/.env`: Contains environment variables for personal preferences

## Customizing After Installation

After the initial setup, you can modify your configuration using:

```bash
# Change profile
dotfiles config profile work

# Enable/disable modules
dotfiles config enable cloud
dotfiles config disable ai

# Apply changes
dotfiles apply all
```

## Advanced Usage

For advanced customization, you can:

1. Edit `~/.extra/config.yaml` directly
2. Create custom profiles in `etc/core/config.yaml`
3. Add environment variables to `~/.extra/.env`

See the [Customization Guide](CustomizationGuide.md) for more details.
