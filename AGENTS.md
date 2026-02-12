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
- **Development Tools**: Git, Vim, Python, Node, Ruby, Go, Terraform
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

## Installation Philosophy

- Modular install scripts in `install/` directory
- Each script handles one tool/environment
- Symlinks from `etc/` to appropriate home directory locations
- Idempotent - safe to run multiple times
- Uses `install/utils.sh` for common functions

## File Modification Guidelines

### When Modifying Dotfiles

1. **Test locally first** - Changes affect your entire development environment
2. **Maintain symlink structure** - Files in `etc/` are symlinked to home directory
3. **Keep it minimal** - Only include essential configuration
4. **Document non-obvious choices** - Add comments for complex configurations

### When Modifying Zsh Configuration

1. **Understand the loading order** - Changes in `.zshenv` affect all shells, `.zshrc` only
   interactive
2. **Use conf.d for new features** - Add topic-specific files to `etc/zsh/conf.d/` (loaded by
   Zephyr confd plugin)
3. **Update plugin manifest** - Edit `.zsh_plugins.txt` and regenerate static file with
   `antidote bundle`
4. **Test startup performance** - Use `ZSH_PROFILE_RC=1 zsh` to profile startup time
5. **Defer non-essential plugins** - Add `kind:defer` to plugins in `.zsh_plugins.txt` for faster
   startup
6. **Platform-specific configs** - Use `.zsh-darwin` or `.zsh-linux` suffixes for OS-specific files
7. **Regenerate static file** - After changing `.zsh_plugins.txt`, run:
   `antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh`

### When Modifying Install Scripts

1. **Preserve idempotency** - Scripts must be safe to run multiple times
2. **Use utility functions** - Leverage `install/utils.sh` helpers
3. **Check for existing installations** - Don't reinstall unnecessarily
4. **Handle both macOS and Linux** - Use `is-macos` and `is-debian` checks
5. **Print clear status messages** - Use `print_header` and success/error indicators

### When Modifying Kiro CLI Configs

1. **Security first** - Maintain restrictive `allowedTools` and `toolsSettings`
2. **Test agent behavior** - Verify tools and permissions work as expected
3. **Keep resources focused** - Only include relevant steering files per agent
4. **Document agent purpose** - Update `description` field when changing behavior

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
- **Editors**: Vim, Sublime Text
- **Version Control**: Git with custom aliases and hooks
- **AI Tools**: Kiro CLI with custom agents and MCP servers

## Common Tasks

### Adding a New Tool Configuration

1. Create directory: `etc/<tool>/`
2. Add config files to `etc/<tool>/`
3. Create install script: `install/<tool>.sh`
4. Add symlink logic to install script
5. Source install script in `install.sh`
6. Document in `docs/ToolConfigurations.md`

### Updating Kiro CLI Agents

1. Edit agent JSON in `etc/kiro-cli/cli-agents/`
2. Test with `kiro-cli chat --agent <agent-name>`
3. Verify tools and permissions work correctly
4. Update steering files if needed in `etc/kiro-cli/steering/`

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
