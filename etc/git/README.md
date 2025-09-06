# Git Configuration

A comprehensive Git configuration system with context-aware settings, enhanced diff visualization,
and automated workflow hooks.

## Philosophy

- **Context-aware**: Different configurations for personal, work, and platform-specific contexts
- **Enhanced visualization**: Delta integration for superior diff and merge conflict display
- **Automated quality**: Git hooks for testing and repository maintenance
- **Conventional commits**: Structured commit message templates and AI-assisted commit generation
- **Security-first**: SSH signing, fsck validation, and credential management

## Directory Structure

```text
etc/git/
├── config                 # Main Git configuration with aliases and core settings
├── config-macos          # macOS-specific settings (credential helper)
├── config-linux          # Linux-specific settings
├── config-uniteus        # Work-specific configuration (email, signing key, repos)
├── commit-template       # Conventional commit message template
├── ignore                # Global gitignore patterns
└── hooks/                # Git hooks for automation
    ├── post-checkout     # Repository setup after clone/checkout
    └── pre-push          # Quality checks before push (tests, linting)
```

## Architecture Overview

### Configuration Hierarchy

The main `config` file includes context-specific configurations using `includeIf` directives:

- **Platform detection**: Automatically loads macOS or Linux settings based on directory paths
- **Work context**: Loads work-specific settings for projects in `~/projects/unite-us/`
- **Cascading settings**: Work and platform configs override base configuration as needed

### Core Features

- **Enhanced diff visualization**: Delta integration with Nord color scheme and side-by-side view
- **Comprehensive aliases**: Productivity shortcuts for common workflows and AI-assisted operations
- **Security configuration**: SSH signing, credential helpers, and fsck validation
- **Performance optimization**: Commit graphs, pruning, and maintenance settings
- **Quality automation**: Pre-push hooks for testing and post-checkout repository setup

### Key Conventions

- **Conventional commits**: Template-guided commit messages with type/scope/subject format
- **Fast-forward only**: Merge and pull strategies that maintain linear history
- **Auto-stash rebasing**: Seamless rebase operations with automatic stash management
- **SSH over HTTPS**: Automatic URL rewriting for GitHub operations

## Finding Specific Information

- **Aliases and shortcuts**: Check `config` file alias section for productivity commands
- **Platform settings**: Look in `config-macos` or `config-linux` for OS-specific configurations
- **Work configuration**: See `config-uniteus` for work-specific email, signing, and repositories
- **Commit guidelines**: Reference `commit-template` for conventional commit format
- **Global ignores**: Check `ignore` file for universal gitignore patterns
- **Automation**: Examine `hooks/` directory for pre-push testing and post-checkout setup
- **Delta styling**: Find diff visualization settings in the delta section of main `config`

This configuration provides a complete Git workflow system optimized for multiple contexts while
maintaining consistency and automation across different development environments.
