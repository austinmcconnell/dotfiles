# Configuration System

This document explains the new configuration system that separates core functionality from user preferences
in the dotfiles repository.

## Overview

The configuration system is designed to:

1. Separate core functionality from user preferences
2. Allow easy customization without modifying core files
3. Support different profiles for different use cases
4. Enable modular installation and configuration

## Structure

The configuration system consists of:

- **Core Configuration**: Defined in `etc/core/config.yaml`
- **User Configuration**: Stored in `~/.extra/config.yaml`
- **Configuration Manager**: A tool for managing configurations (`bin/config-manager`)

## Core Configuration

The core configuration defines:

- Available modules and their components
- Default settings for each module
- Predefined profiles for different use cases

Example structure:

```yaml
# Core configuration
modules:
  shell:
    name: "Shell Environment"
    description: "Zsh configuration with plugins and themes"
    default: true
    components:
      - zsh
      - prompt
      - aliases

profiles:
  default:
    name: "Default Profile"
    description: "Standard configuration for personal use"
    modules:
      shell: true
      development: true
```

## User Configuration

The user configuration overrides settings from the core configuration:

```yaml
# User configuration
profile: work  # Selected profile

modules:
  # Override specific module settings
  cloud:
    enabled: false

  # Enable only specific components
  development:
    enabled: true
    components:
      - git
      - python
```

## Using the Configuration System

### Managing Profiles

To view or change the active profile:

```bash
dotfiles config profile          # View current profile
dotfiles config profile work     # Switch to work profile
dotfiles config profile minimal  # Switch to minimal profile
```

### Managing Modules

To list, enable, or disable modules:

```bash
dotfiles config list-modules     # List all available modules
dotfiles config enable cloud     # Enable the cloud module
dotfiles config disable ai       # Disable the AI module
```

### Checking Status

To check if a module or component is enabled:

```bash
dotfiles config is-enabled development        # Check if development module is enabled
dotfiles config is-enabled development python # Check if python component is enabled
```

### Applying Changes

After changing configuration, apply the changes:

```bash
dotfiles apply all       # Apply all configurations
dotfiles apply shell     # Apply only shell configurations
dotfiles apply git       # Apply only git configurations
```

## Available Profiles

The system comes with several predefined profiles:

1. **default**: Standard configuration for personal use
2. **work**: Configuration optimized for work environment
3. **minimal**: Lightweight configuration for servers or minimal setups

## Available Modules

The system includes the following modules:

1. **shell**: Zsh configuration with plugins and themes
2. **package_managers**: System package managers (Homebrew, APT)
3. **development**: Programming languages and development tools
4. **system**: OS-specific settings and configurations
5. **applications**: Desktop applications and utilities
6. **cloud**: Cloud service provider tools and configurations
7. **ai**: AI assistant configurations and integrations

## Creating Custom Profiles

To create a custom profile, add it to the core configuration file:

```yaml
profiles:
  custom:
    name: "Custom Profile"
    description: "My custom configuration"
    extends: ["default"]  # Inherit from default profile
    modules:
      development:
        enabled: true
        components:
          - git
          - python
      cloud: false
```

## Best Practices

1. **Use User Configuration**: Make changes in `~/.extra/config.yaml` rather than modifying core files
2. **Start with a Profile**: Choose a predefined profile as a starting point
3. **Apply Changes**: Run `dotfiles apply` after changing configuration
4. **Test Changes**: Run `dotfiles test` to verify that everything works correctly
5. **Back Up Configuration**: Keep a backup of your user configuration
