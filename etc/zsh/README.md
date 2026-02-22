# Zsh Configuration

A comprehensive Zsh configuration system built on the Zephyr framework with modular architecture,
intelligent completions, and productivity-focused tooling.

## Philosophy

- **Modular architecture**: Organized configuration files for maintainability and performance
- **Framework-based**: Built on Zephyr framework for consistent, well-tested functionality
- **Performance-first**: Lazy loading, caching, and parallel plugin loading for fast startup
- **Developer-focused**: Git integration, fuzzy finding, and AI-assisted workflows
- **Extensible**: Plugin system with custom functions and abbreviations

## Directory Structure

```text
etc/zsh/
├── .zshrc                 # Main interactive shell configuration
├── .zshenv                # Environment variables for all shells
├── .zprofile              # Login shell configuration
├── .zlogin                # Post-login configuration
├── .zstyles               # Plugin and framework styling configuration
├── .zsh_plugins.txt       # Plugin manifest for Antidote plugin manager
├── conf.d/                # Modular configuration files by topic
├── functions/             # Custom shell functions
├── completions/           # Custom tab completion definitions
├── custom/                # Local customizations and extra plugins
└── zsh-abbr/              # Command abbreviations and shortcuts
```

## Architecture Overview

### Configuration Loading Order

Zsh configuration follows the standard loading sequence with framework integration:

1. **`.zshenv`** - Core environment variables and XDG directories
2. **`.zprofile`** - Login shell environment setup
3. **`.zshrc`** - Interactive shell configuration with plugin loading
4. **`.zlogin`** - Post-login initialization

### Plugin Management

Uses Antidote plugin manager with Zephyr framework components:

- **Framework plugins**: Core Zephyr components for history, completion, utilities
- **External plugins**: Community plugins for enhanced functionality
- **Custom plugins**: Local customizations and work-specific configurations
- **Deferred loading**: Performance optimization for non-essential plugins

### Modular Configuration (conf.d/)

Topic-based configuration files loaded automatically:

- **Development tools**: Git, Docker, Terraform, Python, Node.js, Ruby
- **System integration**: macOS, Homebrew, iTerm2, direnv
- **Productivity**: FZF, AI prompts, filesystem utilities
- **Platform-specific**: Conditional loading based on operating system

### Key Conventions

- **XDG compliance**: Follows XDG Base Directory specification
- **Performance optimization**: Caching, parallel loading, and lazy initialization
- **Conditional loading**: Platform and context-aware configuration
- **Abbreviation system**: Short aliases that expand for common commands

## Finding Specific Information

- **Plugin configuration**: Check `.zstyles` for framework and plugin settings
- **Plugin list**: See `.zsh_plugins.txt` for all loaded plugins
- **Topic-specific settings**: Look in `conf.d/{topic}.zsh` files
- **Custom functions**: Browse `functions/` directory for utility functions
- **Command shortcuts**: Check `zsh-abbr/user-abbreviations` for abbreviations
- **Completions**: Find custom completions in `completions/` directory
- **Local customizations**: See `custom/` directory for additional plugins
- **Environment setup**: Reference `.zshenv` for core environment variables
- **Framework documentation**: Check `zephyr.md` and related docs for framework details

## Key Features

### Development Workflow

- Git integration with fuzzy selection for branches, commits, and files
- AI-assisted command generation and prompt management
- Docker and container orchestration shortcuts
- Language-specific environment management (Python, Node.js, Ruby)

### Productivity Tools

- FZF integration for file, directory, and history search
- Command abbreviations for frequently used operations
- Intelligent tab completion with caching
- Shared history across multiple shell sessions

### System Integration

- Homebrew package manager integration
- macOS-specific optimizations and iTerm2 integration
- Directory environment management with direnv
- XDG Base Directory compliance for clean home directory

This configuration provides a complete shell environment optimized for development workflows while
maintaining fast startup times and extensibility for custom requirements.
