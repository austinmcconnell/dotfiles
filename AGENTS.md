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

## Custom Agent Conventions

This repo manages kiro-cli agents as dotfiles rather than using the standard `.kiro/agents/` or
`~/.kiro/agents/` locations. The conventions below document repo-specific patterns that go beyond
the
[official configuration reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/).

### File Layout

- Agent configs live in `etc/kiro-cli/cli-agents/<name>.json` (symlinked to `~/.kiro/agents/` by
  `install/kiro-cli.sh`)
- Each agent has a co-located prompt file: `etc/kiro-cli/cli-agents/<name>-prompt.md`
- Prompts use relative `file://` URIs: `"prompt": "file://./default-prompt.md"`
- Hook scripts live in `etc/kiro-cli/hooks/` and are referenced by absolute path
  (`~/.dotfiles/etc/kiro-cli/hooks/<script>.sh`)
- Steering docs (principles) go in `etc/kiro-cli/steering/<domain>/**/*.md`
- Skills (workflows, templates) go in `.kiro/skills/<category>/**/SKILL.md` — see
  `skill-loading-triggers` steering for the mapping

### Tool Access Model

All agents use `"tools": ["*"]` to make every tool _available_, then restrict what runs unprompted
via `allowedTools`. This is the inverse of the official examples, which list specific tools in
`tools`. The effect: agents can use any tool if the user approves, but only `allowedTools` entries
run without a prompt.

Each agent's `allowedTools` is scoped to its purpose:

- **default** — broad read access, git read tools, code search, knowledge, web, subagent
- **github** — adds `@github/*` read tools and `@time/*`, no write GitHub tools
- **docs** — same read tools as default, no domain-specific MCP tools
- **jira** — adds `@jira/*` read tools and `@time/*`, no mutating JIRA tools in allowedTools

Write tools (`write`, `shell`, `@git/git_add`, `@git/git_commit`) are intentionally excluded from
every agent's `allowedTools` — the user must approve each write operation.

### Security Layers

Security is enforced at three levels, evaluated in order:

1. **Hooks** — `preToolUse` with `matcher: "*"` runs `block-env-files.sh` on _every_ agent. This
   hook inspects all tool inputs for `.env` file paths and exits `2` (block) if found. It is the
   first line of defense and cannot be bypassed by `allowedTools` or `toolsSettings`.
1. **toolsSettings** — per-tool path and command restrictions:
   - `shell.deniedCommands` — regex patterns checked before `allowedCommands`. Every agent denies
     `.env` access via patterns like `cat .*\\.env.*`. Deny lists are agent-specific (github denies
     `aws .*`, jira denies `pip install .*`, etc.)
   - `shell.allowedCommands` — regex patterns for permitted commands. Unmatched commands require
     user approval. Note: patterns are full regex, not simple strings (e.g.,
     `(GIT_PAGER=cat )?git log.*`, `ls( .*)?`)
   - `write.allowedPaths` / `write.deniedPaths` — restrict file writes to project directories, block
     system paths
   - `grep.deniedPaths` / `glob.deniedPaths` — block `.env` file discovery via search tools
1. **allowedTools** — the whitelist of tools that skip user approval (see Tool Access Model above)

### Audit Logging

The default agent logs sensitive operations to `~/.kiro/logs/`:

- `use_aws` matcher → appends to `aws-audit.jsonl`
- `@kubernetes` matcher → appends to `kubectl-audit.jsonl`
- `execute_bash` matcher → `audit-shell-commands.sh` catches `aws` and `kubectl` invoked via shell

Other agents do not have audit hooks — they deny these commands outright via `deniedCommands`.

### Hook Patterns

- `agentSpawn` — only default uses this (runs `git status --short --branch`). Other agents leave it
  empty since they don't need git context at startup.
- `preToolUse` — every agent has the `block-env-files.sh` hook on `matcher: "*"`. Default adds audit
  hooks for `use_aws`, `@kubernetes`, and `execute_bash`.
- `userPromptSubmit` — declared as empty arrays in github and jira configs for explicitness.

### MCP Server Conventions

- `includeMcpJson: true` on all agents — merges servers from `~/.kiro/settings/mcp.json` and
  `<cwd>/.kiro/settings/mcp.json` into the agent's server list
- Agent-specific servers are declared inline in the config (github has `github` + `time`, jira has
  `jira` + `time`, default has `kubernetes`)
- Use `"disabled": true` to define a server without starting it (default's `kubernetes` server). The
  config stays version-controlled and ready to enable.
- Use `"disabledTools"` to block specific MCP tools (jira blocks `jira_delete_worklog`)
- Secrets use `${ENV_VAR}` interpolation in `env` blocks:
  `"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}"`
- Agents that don't need a service deny it entirely via `toolsSettings` (github and jira set
  `aws.allowedServices: []`, docs denies `docker .*` and `kubectl .*` in shell)

### Resource Patterns

Resources use three URI schemes with different loading behavior:

- `file://` — loaded into context at startup. Used for AGENTS.md, README.md, and steering docs.
  Paths can be relative to cwd (`file://AGENTS.md`) or absolute (`file://~/.dotfiles/etc/...`)
- `skill://` — metadata loaded at startup, full content on demand. Used for SKILL.md files. Agents
  load both project-local (`.kiro/skills/`) and global (`~/.kiro/skills/`) skills.
- `knowledgeBase` objects — indexed for semantic search. Used for large doc sets and codebases.

Resource scoping per agent:

- **default** — all steering domains (`code/`, `security/`), all skill categories, multiple
  knowledge bases (research, project code, analysis docs)
- **github** — `github/` and `security/` steering only, development + shared skills
- **docs** — `documentation/` steering, documentation + shared skills, many knowledge bases for
  cross-project doc work
- **jira** — `scrum/` steering and `env-file-protection.md` only, development + scrum + shared
  skills

### Knowledge Base Conventions

- `indexType: "best"` for documentation and markdown-heavy repos (higher quality search)
- `indexType: "fast"` for code-heavy repos with frequent changes (screenings-ingestion)
- `autoUpdate: true` for actively changing content, `false` for stable cross-project indexes
- Use `include`/`exclude` arrays to scope what gets indexed — exclude `.git/`, `__pycache__/`,
  `.venv/`, `node_modules/`, build artifacts
- Write specific `description` fields — the agent uses these to decide which KB to search
- Knowledge bases referencing repos on other machines (work vs personal) will silently return no
  results — this is expected

### Subagent Trust Model

All agents share the same subagent config:

```json
"subagent": {
    "availableAgents": ["default", "docs", "github", "jira"],
    "trustedAgents": ["default"]
}
```

Only `default` is trusted — subagents spawned as default inherit full tool approval. Other agents
spawned as subagents require user approval for each tool use. This prevents a jira or github
subagent from performing write operations without oversight.

### Adding a New Agent

1. Create `etc/kiro-cli/cli-agents/<name>.json` and `<name>-prompt.md`
1. Start from an existing agent config — copy the closest match
1. Set `tools: ["*"]` and define a restrictive `allowedTools` list
1. Add `block-env-files.sh` as a `preToolUse` hook with `matcher: "*"`
1. Add `.env` deny patterns to `shell.deniedCommands`, `grep.deniedPaths`, and `glob.deniedPaths`
1. Set `includeMcpJson: true`
1. Scope `resources` to only the steering domains and skills the agent needs
1. Set `aws.allowedServices: []` unless the agent needs AWS access
1. Test with `kiro-cli chat --agent <name>`

## Security Considerations

- Never commit API keys, tokens, or passwords
- Use environment variables for sensitive data
- Maintain restrictive shell command deny lists
- Review tool permissions in Kiro CLI agents
- Keep write operations restricted to project directories
