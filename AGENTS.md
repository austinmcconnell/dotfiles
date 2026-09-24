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
- **AI Tools**: Kiro CLI (custom agents), Codex, Cursor, Claude Code (see `etc/ai/` and
  tool-specific dirs)
- **Kubernetes**: Kind cluster configurations and components

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

Print clear status messages (`print_header` and success/error indicators). For the general shell/
install-script conventions (idempotency, `install/utils.sh` helpers, macOS/Linux handling), see
`etc/ai/steering/code/shell-conventions.md` — auto-loaded for Claude Code, Cursor, and Kiro's `code`
agent; read directly for Codex.

### When Modifying Kiro CLI Configs

See `etc/kiro-cli/README.md` for agent JSON conventions, security layers, and the "Adding a New
Agent" checklist.

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

See `etc/ai/steering/code/shell-conventions.md` for shebang, `set -euo pipefail`, quoting, and
naming conventions — auto-loaded for Claude Code, Cursor, and Kiro's `code` agent; read directly for
Codex.

### Configuration Files

- Organize by tool in `etc/<tool>/`
- Use XDG Base Directory specification where possible
- Include README.md in complex config directories

### Git Workflow

See `etc/ai/steering/code/git-conventions.md` for branch naming, commit discipline, and push
workflow — auto-loaded for Claude Code, Cursor, and Kiro's `code` agent; read directly for Codex.
Always: use `.pre-commit-config.yaml` hooks and test changes before committing.

## Tools and Technologies

- **Shell**: Zsh, Bash
- **Languages**: Python, Node.js, Ruby, Go
- **Infrastructure**: Kubernetes (Kind), Terraform, AWS CLI
- **Editors**: Vim (vim-plug, ALE, 20+ plugins), Sublime Text
- **Version Control**: Git with custom aliases and hooks
- **AI Tools**: Kiro CLI with custom agents and MCP servers, Codex, Cursor, Claude Code

## Common Tasks

### Adding a New Tool Configuration

1. Create directory: `etc/<tool>/`
1. Add config files to `etc/<tool>/`
1. Create install script: `install/<tool>.sh`
1. Add symlink logic to install script
1. Source install script in `install.sh`
1. Document in `docs/ToolConfigurations.md`

### Updating Kiro CLI Agents

See `etc/kiro-cli/README.md`.

### Running the Dotfiles Command

- `dotfiles help` - Show available commands
- `dotfiles update` - Update all package managers and packages
- `dotfiles clean` - Clean caches (brew, npm, gem)
- `dotfiles test` - Run test suite
- `dotfiles macos` - Apply macOS system defaults
- `dotfiles dock` - Configure Dock applications

## Multi-Tool AI Configuration

Shared AI assets live in `etc/ai/` and are distributed to each tool by `install/ai-tools.sh`:

- `etc/ai/prompts/` — reusable clipboard-based prompts (tool-agnostic)
- `etc/ai/skills/` — workflow definitions in SKILL.md format
- `etc/ai/steering/` — always-on coding principles and conventions

Tool-specific configs remain in their own directories:

- `etc/kiro-cli/` — agent JSON configs, hooks, settings, MCP server list
- `etc/codex/` — Codex config.toml
- `etc/cursor/` — Cursor CLI permissions and MCP config
- `etc/claude-code/` — Claude Code permissions (settings.json)

See `etc/ai/README.md` for the full distribution matrix.

## Custom Agent Conventions

Kiro-cli agent JSON mechanics (file layout, tool access model, security layers, audit/trace logging,
hook patterns, MCP server conventions, resource patterns, knowledge base conventions, subagent trust
model, and the "Adding a New Agent" checklist) are Kiro-cli-specific and don't apply to Claude Code,
Cursor, or Codex — see **`etc/kiro-cli/README.md`** for the full documentation.

The cross-tool convention that *does* apply everywhere: this repo manages agent/persona configs as
dotfiles rather than using each tool's default discovery location (`.kiro/agents/`,
`~/.claude/agents/`), and shared cross-tool hooks live in `etc/ai/hooks/` while steering docs live
in `etc/ai/steering/<domain>/**/*.md` (see `skill-loading-triggers` steering for the skill mapping).

## Claude Code Conventions

Claude Code-specific configuration mechanics (permission model, hooks, MCP schema, persona
frontmatter, and the full "What Claude Code Does NOT Have vs kiro-cli" comparison) live in
**`etc/claude-code/README.md`** rather than here — Cursor, Codex, and Kiro-cli never act on this
mechanism directly, and (as of Claude Code v2.1.277+) that file is *also* the more appropriate home
because Claude Code now auto-loads this very file (`AGENTS.md`) as project context whenever no
`CLAUDE.md` exists above the working directory, and a user-scope `~/.claude/CLAUDE.md` (what this
repo generates) doesn't count against that check. Keeping Claude-only plumbing documentation here
would mean Claude re-reading meta-documentation about its own configuration every session for no
coding-task benefit — see `etc/claude-code/README.md`'s "What Claude Code Does NOT Have" section for
the full exception writeup, and `analysis/claude-code-changes.md` for the research behind the
original decision to keep the default `claude-md-or-agents-md` setting rather than opt out.

## Security Considerations

Security principles (credential handling, environment variables, deny lists) are documented once in
`etc/ai/steering/security/*.md` — auto-loaded for Claude Code, Cursor, and Kiro-cli; read directly
for Codex. Repo-specific reminder: review tool permissions in Kiro CLI agents
(`etc/kiro-cli/README.md`) and Claude Code personas (`etc/claude-code/README.md`) when changing
either.
