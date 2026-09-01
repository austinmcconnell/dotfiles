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

1. Edit agent JSON in `etc/kiro-cli/cli-agents/`
1. Test with `kiro-cli chat --agent <agent-name>`
1. Verify tools and permissions work correctly
1. Update steering files if needed in `etc/ai/steering/`

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

This repo manages kiro-cli agents as dotfiles rather than using the standard `.kiro/agents/` or
`~/.kiro/agents/` locations. The conventions below document repo-specific patterns that go beyond
the
[official configuration reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/).

### File Layout

- Agent configs live in `etc/kiro-cli/cli-agents/<name>.json` (symlinked to `~/.kiro/agents/` by
  `install/kiro-cli.sh`)
- Each agent has a co-located prompt file: `etc/kiro-cli/cli-agents/<name>-prompt.md`
- Prompts use relative `file://` URIs: `"prompt": "file://./default-prompt.md"`
- Hook scripts live in `etc/kiro-cli/hooks/` (genuinely kiro-only: KB staleness, trace logging) and
  `etc/ai/hooks/` (cross-tool: security denies, correction-capture, audit-shell-commands, and
  `recall-memory.sh`/`check-engram-hygiene.sh` — moved here from `etc/kiro-cli/hooks/` once Claude
  Code started wiring them too), referenced via the `$AI_DOTFILES_DIR` env var
  (`$AI_DOTFILES_DIR/etc/<location>/hooks/<script>.sh`, which resolves to `~/.dotfiles` by default)
- Steering docs (principles) go in `etc/ai/steering/<domain>/**/*.md`
- Skills (workflows, templates) go in `.kiro/skills/<category>/**/SKILL.md` — see
  `skill-loading-triggers` steering for the mapping

### Tool Access Model

All agents use `"tools": ["*"]` to make every tool *available*, then restrict what runs unprompted
via `allowedTools`. This is the inverse of the official examples, which list specific tools in
`tools`. The effect: agents can use any tool if the user approves, but only `allowedTools` entries
run without a prompt.

Each agent's `allowedTools` is scoped to its purpose:

- **default** — broad read access, git read tools, `gh` CLI commands, code search, knowledge, web,
  subagent
- **docs** — same read tools as default, no domain-specific MCP tools
- **jira** — adds `@jira/*` read tools, no mutating JIRA tools in allowedTools
- **datadog** — read tools + Pup CLI read-only commands for querying Datadog (monitors, logs,
  metrics, dashboards, synthetics)

Write tools (`write`, `shell`) are intentionally excluded from every agent's `allowedTools` — the
user must approve each write operation. Git write commands (`git add`, `git commit`) are not in
`shell.allowedCommands`, so they also require explicit user approval before each use.

### Security Layers

Security is enforced at three levels, evaluated in order:

1. **Hooks** — `preToolUse` with `matcher: "*"` runs `block-env-files.sh` on *every* agent. This
   hook inspects all tool inputs for `.env` file paths and exits `2` (block) if found. It is the
   first line of defense and cannot be bypassed by `allowedTools` or `permissions`.
1. **Permissions / toolsSettings** — per-tool path and command restrictions. The configs contain
   both formats for V2/V3 compatibility:
   - **V2 (`toolsSettings`)** — regex-based `shell.deniedCommands` / `shell.allowedCommands`, path
     restrictions on `write`, `grep`, `glob`, and `read` tools
   - **V3 (`permissions.rules`)** — capability-based rules with `match` (glob patterns), `exclude`,
     and `effect` (deny/ask/allow). Effects resolve by restrictiveness: deny > ask > allow
   - Both express the same intent: deny secrets access, allow read-only commands, block destructive
     operations
   - The shell deny rule includes `"exclude": ["chmod +x *"]` to prevent the broadened glob
     `"chmod * *"` from blocking executable permission grants under V3's deny-takes-precedence model
   - The two engines spell the chmod deny differently on purpose: V2 uses the precise regex
     `chmod [0-7]{3,4} .*` (octal modes only, no exclude needed), while V3 uses the broad glob
     `chmod * *` plus `"exclude": ["chmod +x *"]` because globs can't express the octal-only match.
     Both deny octal-mode chmod while allowing `chmod +x` — do NOT "reconcile" them into one
     spelling
1. **allowedTools** — the whitelist of tools that skip user approval (see Tool Access Model above)

### Audit Logging

The default agent logs sensitive operations to `~/.kiro/logs/`:

- `use_aws` matcher → appends to `aws-audit.jsonl`
- `@kubernetes` matcher → appends to `kubectl-audit.jsonl`
- `execute_bash` matcher → `audit-shell-commands.sh` catches `aws` and `kubectl` invoked via shell

Other agents do not have audit hooks — they deny these commands outright via `deniedCommands`.

### Trace Logging

The default agent logs all tool calls to session-scoped trace files at
`~/.kiro/logs/traces/<session-id>.jsonl`:

- `postToolUse` with `matcher: "*"` → `trace-tool-call.sh` records tool name, truncated
  input/output, duration, and timestamp
- Sensitive values are redacted via regex before writing (keys matching
  password/secret/token/key/credential/authorization/private)
- Trace directory is created with `700` permissions (owner-only access)
- `rotate-traces.sh` runs on `agentSpawn` to delete files older than 7 days or trim when total size
  exceeds 100MB
- `bin/trace-search` provides CLI querying: filter by tool, grep patterns, session, or date

Trace logging is intentionally scoped to the default agent only — other agents don't need the
overhead, and restricting to one agent avoids write races on shared session files.

### Hook Patterns

Hooks use the V3 array format: each hook is an object with `name`, `trigger`, `matcher` (optional),
`action` (`type` + `command`), and `timeout` (seconds). The V2 engine also reads this format.

- `agentSpawn` — all agents run `recall-memory.sh` (surfaces engram memories for the current
  project) and `check-engram-hygiene.sh`, which delegates to `bin/engram-hygiene check`: a
  time-throttled (6-week default, `ENGRAM_HYGIENE_CADENCE_DAYS`) nudge that fires only when the
  current project has pending engram conflict relations awaiting review. Hygiene is wired to every
  agent (not just the KB-using three) because conflict debt accrues in the shared local DB
  regardless of which agent created the memories — it tracks the `recall-memory.sh` footprint, not
  the `check-research-kb.sh` one. It is deliberately current-project scoped to stay low-noise; the
  all-projects view is the on-demand `dotfiles memory-check` command (`bin/engram-hygiene status`).
  Both are read-only — conflict resolution stays user-approved via `mem_judge`/`mem_compare`, never
  auto-applied. Default, docs, and ansible additionally run `check-research-kb.sh` for KB staleness
  detection (their agent name must appear in the `kb-staleness.sh` sentinel for the warning to
  fire). Default additionally runs `rotate-traces.sh` for trace file cleanup. Claude Code runs the
  same `recall-memory.sh`/`check-engram-hygiene.sh` pair via `SessionStart` (see Claude Code
  Conventions below) — that pair has parity across both tools. The KB-staleness and trace hooks
  remain kiro-only; see "What Claude Code Does NOT Have" for why.
- `preToolUse` — every agent has the `block-env-files.sh`, `block-sops-age-files.sh`, and
  `block-ssh-private-keys.sh` hooks on `matcher: "*"`. Default adds audit hooks for `use_aws`,
  `@kubernetes`, and `execute_bash`. All agents have `block-memory-secrets.sh` on
  `matcher: "@engram/*"` to prevent storing credentials in persistent memory. The glob (`/*`) is
  required because kiro-cli reports MCP tools with the `@server/` prefix (e.g. `@engram/mem_save`);
  a bare `@engram` matcher does not fire and the hook is silently skipped. The hook normalizes both
  MCP naming conventions before comparing (`${TOOL_NAME##*/}` strips kiro's `@server/` prefix,
  `${TOOL_NAME##mcp__*__}` strips Claude Code's `mcp__server__` prefix), so it works for both tools.
- `postToolUse` — default and docs use this (runs `clear-research-kb-stale.sh` after knowledge
  operations to clear staleness warnings). Default also runs `trace-tool-call.sh` on `matcher: "*"`
  for session-scoped trace logging.
- `userPromptSubmit` — every agent runs `correction-capture.sh`. This is the capture half of the
  capture-and-promote learning system (see the `capturing-corrections` steering and the
  `distill-learnings` skill). On each prompt it does two things via stdout (the one hook channel
  documented to reach the model on both kiro-cli and Claude Code): (1) if the prompt looks like a
  correction/preference, it nudges the agent to `mem_save` it immediately with `type: preference`
  and a `topic_key: correction/<area>-<slug>`; (2) if a correction was captured on a prior turn (a
  session-scoped sentinel under `$TMPDIR/ai-corrections/<session>.pending`), it reminds the user to
  run the `distill-learnings` skill, then clears the sentinel. The promotion prompt rides
  `userPromptSubmit` rather than a `stop` hook on purpose: the `stop` event's exit-0 stdout is not
  added to the model's context on either tool, so a stop-based reminder would silently vanish. The
  session key is read from the payload's `session_id` first (Claude Code provides it), then
  `KIRO_SESSION_ID`, then a `date+PID` fallback — matching `trace-tool-call.sh` so parallel sessions
  don't collide on a shared sentinel. These are per-tool paths, not degradation: the kiro-cli
  `userPromptSubmit` payload has only `hook_event_name`, `cwd`, and `prompt` (no `session_id`,
  verified by capturing a real payload), so on kiro the key always comes from the exported
  `KIRO_SESSION_ID`; Claude Code supplies `session_id` in the payload. The `date+PID` branch only
  fires if both are missing. The hook never writes to memory itself (the agent's `mem_save` still
  passes through `block-memory-secrets.sh`) and never promotes anything (promotion is the
  user-approved `distill-learnings` skill). On the Claude Code side the same hook is wired via the
  `UserPromptSubmit` event in `settings.json`.

**Important:** Do not re-run `/upgrade-agent` on agents that have manual edits to the `permissions`
block (e.g., the `exclude` fix on the chmod deny rule). The command regenerates permissions from
`toolsSettings` and will overwrite manual additions.

### MCP Server Conventions

- `includeMcpJson: true` on all agents — merges servers from `~/.kiro/settings/mcp.json` and
  `<cwd>/.kiro/settings/mcp.json` into the agent's server list
- Shared servers in `~/.kiro/settings/mcp.json`: `engram` (cross-session memory, available to all
  agents via `includeMcpJson`)
- Agent-specific servers are declared inline in the config (jira has `jira`, default has
  `kubernetes`)
- Use `"disabled": true` to define a server without starting it (default's `kubernetes` server). The
  config stays version-controlled and ready to enable.
- Use `"disabledTools"` to block specific MCP tools (jira blocks `jira_delete`)
- Secrets use `${ENV_VAR}` interpolation in `env` blocks:
  `"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}"`
- Agents that don't need a service deny it entirely via `toolsSettings` (docs, jira, datadog, and
  ansible set `aws.allowedServices: []`; docs denies `docker .*` and `kubectl .*` in shell). Only
  `default` keeps a populated `allowedServices` list.

### Resource Patterns

Resources use three URI schemes with different loading behavior:

- `file://` — loaded into context at startup. Used for AGENTS.md, README.md, and steering docs.
  Paths can be relative to cwd (`file://AGENTS.md`) or absolute (`file://~/.dotfiles/etc/...`)
- `skill://` — metadata loaded at startup, full content on demand. Used for SKILL.md files. Agents
  load both project-local (`.kiro/skills/`) and global (`~/.kiro/skills/`) skills.
- `knowledgeBase` objects — indexed for semantic search. Used for large doc sets and codebases.

Resource scoping per agent:

- **default** — all steering domains (`code/`, `github/`, `security/`),
  development/operations/research/shared skill categories, multiple knowledge bases (research,
  project code, analysis docs)
- **docs** — `documentation/` steering, documentation + shared skills, many knowledge bases for
  cross-project doc work
- **jira** — `scrum/` steering and `env-file-protection.md` only, development + scrum + shared
  skills
- **ansible** — `ansible/` steering, ansible + shared skills, multiple knowledge bases (geerlingguy
  reference repos, research, homelab docs)
- **datadog** — `datadog/` steering and `env-file-protection.md`, operations + shared skills, no
  knowledge bases

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
    "availableAgents": ["default", "docs", "jira", "ansible", "datadog"],
    "trustedAgents": ["default"]
}
```

Only `default` is trusted — subagents spawned as default inherit full tool approval. Other agents
spawned as subagents require user approval for each tool use. This prevents a jira or docs subagent
from performing write operations without oversight.

### Adding a New Agent

1. Create `etc/kiro-cli/cli-agents/<name>.json` and `<name>-prompt.md`
1. Start from an existing agent config — copy the closest match
1. Set `tools: ["*"]` and define a restrictive `allowedTools` list
1. Add `block-env-files.sh` as a `preToolUse` hook with `matcher: "*"`
1. Add `.env` deny patterns to `shell.deniedCommands`, `grep.deniedPaths`, and `glob.deniedPaths`
1. Set `includeMcpJson: true`
1. Scope `resources` to only the steering domains and skills the agent needs
1. Set `aws.allowedServices: []` unless the agent needs AWS access
1. Run `/upgrade-agent` (in a `kiro-cli --v3` session) on the new agent only to generate its
   `permissions.rules` block, then add the `"exclude": ["chmod +x *"]` to its shell deny rule
1. Test with `kiro-cli chat --agent <name>`

## Claude Code Conventions

Claude Code uses a simpler configuration model than kiro-cli — no agent JSON, and global hooks live
in one `settings.json` event array rather than kiro's per-agent hook blocks. Configuration lives in
`~/.claude/` (user scope) and is managed by `install/claude-code.sh`. Claude Code does support
custom subagents (personas) via markdown files with YAML frontmatter — a different mechanism from
kiro-cli's JSON agent configs, but the same underlying idea, including their own scoped `hooks:`
field for persona-specific hooks; see Personas below.

### File Layout

- `etc/claude-code/settings.json` — permissions (symlinked to `~/.claude/settings.json`)
- `~/.claude/CLAUDE.md` — generated by `install/ai-tools.sh` from steering docs (not version
  controlled directly)
- `~/.claude/skills/` — symlink to `etc/ai/skills/` (created by `install/ai-tools.sh`)
- `~/.claude.json` — MCP servers and session state (bootstrapped by `install/claude-code.sh`, not
  symlinked — contains local state)

### Permission Model

Claude Code uses `allow`/`deny` arrays in `settings.json` with glob-style patterns:

- `Bash(pattern)` — shell command permissions (equivalent to kiro-cli's `shell.allowedCommands`)
- `Read(pattern)` — file read permissions
- `Edit(pattern)` — file write permissions (equivalent to kiro-cli's `write.allowedPaths`)

Deny rules are evaluated first. Unmatched commands prompt for user approval (equivalent to kiro-cli
excluding tools from `allowedTools`).

### Security Parity with Other Tools

The deny list mirrors protections from kiro-cli and Cursor:

- `.env` files blocked via `Read(./.env*)` and `Read(**/.env*)`
- Credential files blocked (`.key`, `.pem`, `credentials*`)
- System paths blocked for writes (`/etc/`, `/usr/`, `/bin/`, `/sbin/`, `/System/`)
- Destructive commands blocked (`rm`, `sudo`, mutating `gh` commands, `kubectl apply/create/delete`)

### MCP Servers

Claude Code stores MCP servers in `~/.claude.json` (user scope) with a different schema than
kiro-cli or Cursor:

```json
{
  "mcpServers": {
    "server-name": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": { "KEY": "${ENV_VAR}" }
    }
  }
}
```

The `type` field (`stdio`, `http`, `sse`) is required — this is the main difference from kiro-cli's
format. Environment variable interpolation uses `${VAR}` syntax (same as kiro-cli).

`install/claude-code.sh` bootstraps `engram` and `jira` into `~/.claude.json` with a `jq` merge:
missing servers are added while existing servers and session state are preserved (existing values
win on key collision). The merge is idempotent, so running the installer against an existing
`~/.claude.json` now lands `engram` rather than skipping the file. `engram` is guarded on the Claude
side by the shared `block-memory-secrets.sh` PreToolUse hook.

### Steering and Skills

Both are handled by `install/ai-tools.sh` — no Claude Code-specific configuration needed:

- **Steering**: `etc/ai/steering/code/` and `security/` concatenated into `~/.claude/CLAUDE.md`
- **Skills**: `etc/ai/skills/` symlinked to `~/.claude/skills/`

### Personas (Subagents)

Claude Code supports custom subagents defined as markdown files with YAML frontmatter in
`etc/claude-code/agents/` (symlinked to `~/.claude/agents/` by `install/claude-code.sh`, invoked via
`claude --agent <name>`). Four personas mirror their kiro-cli counterparts: `docs`, `jira`,
`datadog`, `ansible`. There is no persona equivalent of kiro's `default` agent — the main Claude
Code session fills that role directly.

- `tools:` frontmatter is the closest Claude analog to kiro's `allowedTools` — it gates which tools
  are *available* to the persona at all, not just whether they auto-run without a prompt
- `disallowedTools:` blocks specific tools within an otherwise-available category (e.g. jira's
  `mcp__jira__jira_delete`), mirroring kiro's MCP `disabledTools`
- `mcpServers:` scopes which MCP servers a persona can see (jira restricts to `jira`)
- Domain steering loads via `@`-imports in the persona body (e.g.
  `@~/.dotfiles/etc/ai/steering/ansible/*.md`), not a `resources` array — each persona should import
  the same steering domain its kiro counterpart loads via
  `file://~/.kiro/steering/<domain>/**/*.md`. Keep these in sync when adding steering files: a new
  file in an imported domain directory needs an explicit new `@`-import line added to the persona
  (unlike kiro's glob-based `resources` entries, Claude's `@`-imports are not wildcarded)
- Personas have no kiro-style `knowledgeBase` equivalent. Where the kiro agent indexes local repos
  semantically (docs, ansible), the Claude persona instead documents the same local paths in a
  "Reference Repositories" table so Grep/Glob can be pointed at them manually — functional, not
  semantic, coverage
- Personas support their own scoped `hooks:` frontmatter field (`PreToolUse`/`PostToolUse`, same
  shape as the global `settings.json` arrays), confirmed against current Claude Code docs. All four
  personas use it: `block-persona-shell-commands.sh` runs as a persona-scoped `PreToolUse(Bash)`
  hook, mirroring kiro's per-agent `toolsSettings.shell.deniedCommands`
  (aws/docker/kubectl/ssh/package-manager installs and persona-specific destructive commands)

### What Claude Code Does NOT Have (vs kiro-cli)

- No equivalent to kiro's `default` agent as a *persona* — the main Claude Code session fills that
  role directly (the `docs`/`jira`/`datadog`/`ansible` personas do exist; see Personas above)
- No knowledge base integration (no semantic search over indexed repos). The `docs`/`ansible`
  personas document the same local KB paths in a Reference Repositories table for manual Grep/Glob
  instead (see Personas above). Kiro's `check-research-kb.sh`/`clear-research-kb-stale.sh`
  staleness-nudge hooks were deliberately NOT ported: the nudge tells the user to "ask me to
  re-index," but re-indexing requires kiro's `knowledge` tool, which Claude doesn't have — porting
  the nudge without a way to resolve it would just mislead the user
- No per-tool MCP audit hooks — Claude has no MCP `aws`/`kubernetes` tools to audit, so there's no
  equivalent to the `use_aws`/`@kubernetes` matchers or their
  `aws-audit.jsonl`/`kubectl-audit.jsonl` outputs. Shell-invoked `aws`/`kubectl` commands are still
  audited: `audit-shell-commands.sh` runs globally on `PostToolUse` for `Bash` and writes to
  `~/.local/share/ai-audit/command-audit.jsonl` (a single shared log, not split per-tool like
  kiro's). The trigger timing also differs: kiro's `default` agent wires the same script on
  `preToolUse` for `execute_bash` (audited before the command runs), Claude wires it on
  `PostToolUse` (audited after). Harmless in practice — the script only reads `.tool_input.command`,
  it doesn't need to act before execution — but worth knowing if this script ever grows a blocking
  responsibility
- No `allowedTools` concept in the global permission model (everything is allow/deny/prompt) —
  though a persona's `tools:` frontmatter is a coarser analog (see Personas above)

## Security Considerations

- Never commit API keys, tokens, or passwords
- Use environment variables for sensitive data
- Maintain restrictive shell command deny lists
- Review tool permissions in Kiro CLI agents
- Keep write operations restricted to project directories
