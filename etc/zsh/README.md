# Zsh Configuration with Zephyr and Antidote

This document explains how Zephyr and Antidote work together to create a powerful, modular Zsh environment.

## Table of Contents

- [Overview](#overview)
- [Zephyr Framework](#zephyr-framework)
  - [Core Concepts](#core-concepts)
  - [Plugin System](#plugin-system)
  - [Configuration](#configuration)
- [Antidote Plugin Manager](#antidote-plugin-manager)
  - [Core Concepts](#core-concepts-1)
  - [Bundle Management](#bundle-management)
  - [Performance Optimization](#performance-optimization)
- [Integration](#integration)
  - [Best Practices](#best-practices)
  - [Example Configuration](#example-configuration)

## Overview

The Zsh configuration in this dotfiles repository leverages two powerful tools:

1. **Zephyr**: A lightweight, modular Zsh framework that provides core functionality
2. **Antidote**: A high-performance plugin manager for Zsh

Together, these tools create a fast, flexible, and maintainable Zsh environment that can be
customized to your specific needs.

## Zephyr Framework

Zephyr is a lightweight Zsh framework designed to be modular and fast. It provides essential Zsh
functionality through independent plugins that can be used individually or together.

### Core Concepts

Zephyr is built around several key principles:

- **Modularity**: Each component works independently and can be enabled or disabled
- **Speed**: Optimized for fast shell startup times
- **Simplicity**: Clean, well-organized code that's easy to understand and modify
- **Compatibility**: Works well with other Zsh plugins and tools

### Plugin System

Zephyr organizes functionality into discrete plugins:

- **color**: Terminal color support and configuration
- **completion**: Zsh's powerful completion system
- **compstyle**: Completion styling and configuration
- **confd**: Fish-like configuration directory support
- **directory**: Directory navigation and management
- **editor**: Keybindings and editor integration
- **environment**: Environment variable management
- **history**: Command history configuration
- **homebrew**: Homebrew integration for macOS
- **macos**: macOS-specific functionality
- **prompt**: Prompt configuration (with optional Starship support)
- **utility**: Common shell utilities and functions
- **zfunctions**: Fish-like function autoloading

Each plugin is contained in its own directory with a consistent structure:

```shell
plugins/
  plugin-name/
    plugin-name.plugin.zsh  # Main plugin file
    functions/              # Optional functions directory
    completions/            # Optional completions directory
```

### Configuration

Zephyr uses Zsh's built-in `zstyle` system for configuration. This provides a flexible way to
customize behavior without modifying the core code.

Example configuration:

```zsh
# Specify which plugins to load
zephyr_plugins=(
  zfunctions
  directory
  editor
  history
)
zstyle ':zephyr:load' plugins $zephyr_plugins

# Source Zephyr
source ${ZDOTDIR:-~}/.zephyr/zephyr.zsh
```

Zephyr also supports a post-initialization hook system that allows code to run after Zsh is fully initialized:

```zsh
# Add a function to the post_zshrc hook
post_zshrc_hook+=('my_custom_function')
```

## Antidote Plugin Manager

Antidote is a high-performance Zsh plugin manager that handles downloading, updating, and loading Zsh
plugins. It's a feature-complete implementation of the legacy Antibody plugin manager, with improvements
for speed and usability.

### Core Concepts

Antidote is built around several key features:

- **Speed**: Optimized for fast plugin loading
- **Simplicity**: Easy-to-understand bundle format
- **Flexibility**: Supports various plugin sources and configurations
- **Static Generation**: Creates static load files for maximum performance

### Bundle Management

Antidote uses a simple text file (typically `.zsh_plugins.txt`) to define plugins:

```conf
# Plugin bundles
rupa/z
sindresorhus/pure

# Oh My Zsh plugins
getantidote/use-omz
ohmyzsh/ohmyzsh path:lib
ohmyzsh/ohmyzsh path:plugins/extract

# Fish-like features
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-autosuggestions
zsh-users/zsh-history-substring-search
```

Each line specifies a plugin with optional parameters:

- **GitHub shorthand**: `user/repo` for GitHub repositories
- **Full URLs**: `https://host.com/user/repo` for other git hosts
- **Path specifier**: `path:subdirectory` to load specific parts of a repository
- **Branch/tag/commit**: `branch:main` to specify a git reference
- **Kind**: `kind:defer` for plugins that support deferred loading
- **Clone-only**: `kind:clone` to clone without sourcing
- **FPATH-only**: `kind:fpath` to add to FPATH without sourcing

### Performance Optimization

Antidote offers several performance optimizations:

1. **Static Loading**: Generates a static file that can be sourced directly
2. **Deferred Loading**: Supports loading plugins after Zsh initialization
3. **Parallel Cloning**: Downloads multiple plugins simultaneously
4. **Zcompilation**: Compiles scripts for faster loading

Example of optimized loading:

```zsh
# .zshrc
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (
    source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
  )
fi
source ${zsh_plugins}.zsh
```

## Integration

Zephyr and Antidote work together seamlessly, with Antidote managing plugin installation and Zephyr
providing core functionality.

### Best Practices

1. **Use Zephyr for Core Functionality**:
   - Load Zephyr's modular plugins for essential Zsh features
   - Configure using `zstyle` for flexibility

2. **Use Antidote for External Plugins**:
   - Manage third-party plugins with Antidote
   - Create a static load file for performance

3. **Organize Configuration**:
   - Keep plugin list in `.zsh_plugins.txt`
   - Use Zephyr's `confd` plugin for modular configuration

4. **Optimize Performance**:
   - Use static loading with Antidote
   - Defer non-essential plugins
   - Consider zcompiling frequently used scripts

### Example Configuration

A well-structured Zsh configuration might look like this:

```zsh
# .zshrc

# Load Antidote
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh

# Generate static plugin file if needed
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
fi

# Configure Zephyr
zephyr_plugins=(
  environment
  directory
  history
  editor
  utility
  completion
)
zstyle ':zephyr:load' plugins $zephyr_plugins

# Source Zephyr
source ${ZDOTDIR:-$HOME}/.zephyr/zephyr.zsh

# Source static plugins file
source ${zsh_plugins}.zsh

# Custom configuration
# ...
```

With `.zsh_plugins.txt`:

```conf
# Zephyr core plugins
mattmc3/zephyr path:plugins/color
mattmc3/zephyr path:plugins/completion
mattmc3/zephyr path:plugins/directory
mattmc3/zephyr path:plugins/editor
mattmc3/zephyr path:plugins/history
mattmc3/zephyr path:plugins/utility

# Additional plugins
zsh-users/zsh-autosuggestions kind:defer
zsh-users/zsh-syntax-highlighting kind:defer
zsh-users/zsh-history-substring-search kind:defer

# Prompt
sindresorhus/pure
```

This configuration provides a clean, modular setup that leverages the strengths of both Zephyr and
Antidote while maintaining excellent performance.
