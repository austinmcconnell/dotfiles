# Amazon Q Setup

> **Note:** Amazon Q has been rebranded as **Kiro CLI**. Configuration directories still
> use `amazon-q` for backward compatibility.

This document describes how Kiro CLI is set up in this dotfiles repository.

## Installation

Kiro CLI is installed via the dedicated installation script:

```bash
./install/kiro-cli.sh
```

This script:

1. Installs the Kiro CLI cask using Homebrew
2. Creates necessary configuration directories
3. Links configuration files from the dotfiles repository
4. Installs Kiro CLI integrations (like SSH)
5. Installs MCP servers for extended functionality

## Configuration Files

The configuration files are stored in:

- `etc/kiro-cli/settings.json` - Application settings
- `etc/kiro-cli/cli-agents/*.json` - CLI agent configurations (default, jira, github)
- `etc/kiro-cli/profiles/*/context.json` - Profile-specific contexts
- `etc/kiro-cli/global_rules/**/*.md` - Global guidance documents

## CLI Agents

Kiro CLI uses specialized agents for different tasks. Each agent has its own configuration in `etc/kiro-cli/cli-agents/`:

- **default.json** - General development assistant with AWS, database, and infrastructure capabilities
- **jira.json** - JIRA-focused agent for SCRUM and user story management
- **github.json** - GitHub-focused agent for repository and code management

Each agent configuration includes:

- `resources` - Markdown files providing context and guidance
- `mcpServers` - MCP server integrations (filesystem, git, time, fetch, postgres, jira)
- `allowedTools` - Specific tools the agent can use
- `toolsSettings` - Security restrictions and tool configurations

## Command Usage

You can use either command:

- `kiro-cli` - The official command
- `q` - Legacy wrapper (shows deprecation warning)

Examples:

```bash
kiro-cli chat                    # Start interactive chat
kiro-cli chat --agent jira       # Use JIRA agent
q "How do I create a Python virtual environment?"
```

## Manual Steps

After installation, you may need to:

1. Launch Kiro CLI and sign in with your AWS account
2. Configure any additional integrations through the UI
3. Customize settings as needed

## Troubleshooting

If you encounter issues:

1. Check that the configuration directories exist
2. Verify that the symbolic links are correctly established
3. Restart Kiro CLI after making configuration changes
