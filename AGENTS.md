# Dotfiles Repository Context

## Repository Purpose

Personal macOS development environment configuration repository. This is a **dotfiles repo** - not
application code. All changes should maintain the philosophy of minimal, focused configuration that
works across fresh macOS installations.

## Repository Structure

### Core Directories

- `bin/` - Custom executable scripts and utilities
- `etc/` - Configuration files organized by tool (git, zsh, vim, python, kiro-cli, etc.)
- `install/` - Modular installation scripts for setting up tools and environments
- `scripts/` - Helper scripts for automation and analysis
- `macos/` - macOS-specific settings (Dock, system defaults)
- `docs/` - Documentation for setup and customization
- `tests/` - Zunit tests for shell functions

### Key Configuration Areas

- **Shell**: Zsh with antidote plugin manager, custom functions, completions
- **Development Tools**: Git, Vim (with ALE linting), Python, Node, Ruby, Go, Terraform
- **Kiro CLI**: Custom agents (default, github, jira) with security restrictions
- **Kubernetes**: Kind cluster configurations and components
- **AI Prompts**: Reusable prompts for code analysis and documentation

### Zsh Configuration Architecture

- **Framework**: Zephyr (modular, lightweight framework)
- **Plugin Manager**: Antidote (high-performance, static loading)
- **Loading Order**: `.zshenv` → `.zprofile` → `.zshrc` → `.zlogin`
- **Plugin Manifest**: `etc/zsh/.zsh_plugins.txt` defines all plugins
- **Static Loading**: Antidote generates `.zsh_plugins.zsh` for fast startup
- **Modular Config**: Topic-based files in `etc/zsh/conf.d/` (auto-loaded by Zephyr confd plugin)
- **Custom Functions**: Autoloaded from `etc/zsh/functions/`
- **Completions**: Custom completions in `etc/zsh/completions/`
- **Abbreviations**: Command shortcuts via zsh-abbr in `etc/zsh/zsh-abbr/`

### Vim Configuration Architecture

- **Plugin Manager**: vim-plug (automatic installation and management)
- **Configuration File**: `etc/vim/.vimrc` (symlinked to `~/.vim/vimrc`)
- **Modular Plugins**: Each plugin has its own config file in `etc/vim/plugin/`
- **Primary Linter/Fixer**: ALE (Asynchronous Lint Engine) with language-specific configs
- **Language Settings**: Override files in `etc/vim/after/ftplugin/` for per-language customization
- **Custom Syntax**: Language-specific syntax files in `etc/vim/syntax/`
- **Filetype Detection**: Custom rules in `etc/vim/filetype.vim`
- **Leader Key**: Semicolon (`;`) for custom mappings
- **Dependencies**: ctags (tag generation), the_silver_searcher (ag for searching)
- **Philosophy**: Git-centric, auto-saving, comprehensive tooling, cross-platform
- **Detailed Documentation**: See `etc/vim/README.md` for complete architecture overview

## Installation Philosophy

- Modular install scripts in `install/` directory
- Each script handles one tool/environment
- Symlinks from `etc/` to appropriate home directory locations
- Idempotent - safe to run multiple times
- Uses `install/utils.sh` for common functions

## File Modification Guidelines

### When Modifying Dotfiles

1. **Test locally first** - Changes affect your entire development environment
1. **Maintain symlink structure** - Files in `etc/` are symlinked to home directory
1. **Keep it minimal** - Only include essential configuration
1. **Document non-obvious choices** - Add comments for complex configurations

### When Modifying Zsh Configuration

1. **Understand the loading order** - Changes in `.zshenv` affect all shells, `.zshrc` only
   interactive
1. **Use conf.d for new features** - Add topic-specific files to `etc/zsh/conf.d/` (loaded by Zephyr
   confd plugin)
1. **Update plugin manifest** - Edit `.zsh_plugins.txt` and regenerate static file with
   `antidote bundle`
1. **Test startup performance** - Use `ZSH_PROFILE_RC=1 zsh` to profile startup time
1. **Defer non-essential plugins** - Add `kind:defer` to plugins in `.zsh_plugins.txt` for faster
   startup
1. **Platform-specific configs** - Use `.zsh-darwin` or `.zsh-linux` suffixes for OS-specific files
1. **Regenerate static file** - After changing `.zsh_plugins.txt`, run:
   `antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh`

### When Modifying Install Scripts

1. **Preserve idempotency** - Scripts must be safe to run multiple times
1. **Use utility functions** - Leverage `install/utils.sh` helpers
1. **Check for existing installations** - Don't reinstall unnecessarily
1. **Handle both macOS and Linux** - Use `is-macos` and `is-debian` checks
1. **Print clear status messages** - Use `print_header` and success/error indicators

### When Modifying Kiro CLI Configs

1. **Security first** - Maintain restrictive `allowedTools` and `toolsSettings`
1. **Test agent behavior** - Verify tools and permissions work as expected
1. **Keep resources focused** - Only include relevant steering files per agent
1. **Document agent purpose** - Update `description` field when changing behavior

### When Modifying Vim Configuration

1. **Understand the modular structure** - Each plugin has its own config file in `etc/vim/plugin/`
1. **Modify plugin configs, not .vimrc** - Keep `.vimrc` for general settings, use `plugin/` for
   plugin-specific configs
1. **Language-specific settings** - Add overrides to `etc/vim/after/ftplugin/{language}.vim`
1. **ALE linter/fixer changes** - Edit `etc/vim/plugin/ale.vim` for language tool configurations
1. **Test changes immediately** - Reload vim with `:source ~/.vim/vimrc` or restart vim
1. **Check plugin installation** - Run `:PlugInstall` after adding new plugins to `.vimrc`
1. **Reference the README** - See `etc/vim/README.md` for detailed architecture and conventions

## Key Conventions

### Shell Scripts

- Use `#!/bin/bash` or `#!/usr/bin/env zsh`
- Set `set -euo pipefail` for safety
- Source `install/utils.sh` for install scripts
- Use descriptive function names

### Configuration Files

- Organize by tool in `etc/<tool>/`
- Use XDG Base Directory specification where possible
- Include README.md in complex config directories
- Keep sensitive data out of repo (use environment variables)

### Git Workflow

- Commit messages follow conventional format
- Test changes before committing
- Use `.pre-commit-config.yaml` hooks
- Keep commits focused and atomic

## Tools and Technologies

- **Shell**: Zsh, Bash
- **Languages**: Python, Node.js, Ruby, Go
- **Infrastructure**: Kubernetes (Kind), Terraform, AWS CLI
- **Editors**: Vim (vim-plug, ALE, 20+ plugins), Sublime Text
- **Version Control**: Git with custom aliases and hooks
- **AI Tools**: Kiro CLI with custom agents and MCP servers

## Common Tasks

### Adding a New Tool Configuration

1. Create directory: `etc/<tool>/`
1. Add config files to `etc/<tool>/`
1. Create install script: `install/<tool>.sh`
1. Add symlink logic to install script
1. Source install script in `install.sh`
1. Document in `docs/ToolConfigurations.md`

### Updating Kiro CLI Agents

1. Edit agent JSON in `etc/kiro-cli/cli-agents/`
1. Test with `kiro-cli chat --agent <agent-name>`
1. Verify tools and permissions work correctly
1. Update steering files if needed in `etc/kiro-cli/steering/`

### Running the Dotfiles Command

- `dotfiles help` - Show available commands
- `dotfiles update` - Update all package managers and packages
- `dotfiles clean` - Clean caches (brew, npm, gem)
- `dotfiles test` - Run test suite
- `dotfiles macos` - Apply macOS system defaults
- `dotfiles dock` - Configure Dock applications

## Security Considerations

- Never commit API keys, tokens, or passwords
- Use environment variables for sensitive data
- Maintain restrictive shell command deny lists
- Review tool permissions in Kiro CLI agents
- Keep write operations restricted to project directories
