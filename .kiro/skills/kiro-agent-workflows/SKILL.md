---
name: kiro-agent-workflows
description: Guide for using Kiro CLI custom agents, when to use each agent, how to create new agents, and MCP server configuration. Use when switching agents, adding new agents, configuring MCP servers, or understanding agent architecture.
---

# Kiro Agent Workflows

## Agent Architecture

**Peer agent model:**

- Three specialized agents: default, github, jira
- Manual switching via `/agent swap`
- Each agent has specific tools and permissions
- No hierarchical delegation between agents

**Why peer agents?**

- Clear separation of concerns
- Explicit context switching
- Predictable tool availability
- Security through isolation

## When to Use Each Agent

### Default Agent

**Use for:**

- General development tasks
- AWS operations (read-only by default)
- Kubernetes operations (read-only)
- File operations in project directories
- Git operations (read-only)
- Web research

**Switch to default:**

```bash
/agent swap default
```

### GitHub Agent

**Use for:**

- GitHub repository operations
- Issue and PR management
- Code search across repositories
- Release management
- Team and organization queries

**Switch to github:**

```bash
/agent swap github
```

### JIRA Agent

**Use for:**

- JIRA issue management
- Sprint planning and tracking
- Worklog queries
- Project and status information

**Switch to jira:**

```bash
/agent swap jira
```

## Creating a New Agent

See `references/agent-configuration.md` for detailed configuration fields and examples.

**Quick steps:**

1. Create agent JSON in `~/.dotfiles/etc/kiro-cli/cli-agents/`
2. Create prompt file
3. Run `./install/kiro-cli.sh` to link
4. Test with `kiro-cli chat --agent myagent`

## MCP Server Setup

See `references/mcp-servers.md` for installation and configuration details.

**Quick reference:**

- Global config: `~/.kiro/settings/mcp.json`
- Agent-specific: In agent JSON `mcpServers` field
- Set `includeMcpJson: true` to include both

## Security Configuration

See `references/security.md` for detailed security patterns.

**Key principles:**

- Restrictive by default
- Audit sensitive operations
- Explicit tool permissions
- Path-based restrictions

## Agent Switching

**Commands:**

```bash
/agent swap default   # General development
/agent swap github    # GitHub operations
/agent swap jira      # JIRA operations
/agent status         # Check current agent
/agent list           # List available agents
```

## Troubleshooting

**Agent not found:**

```bash
ls ~/.kiro/agents/
./install/kiro-cli.sh
```

**MCP server not working:**

```bash
/tools  # Check server status in chat
```

**Tool permission denied:**

- Check `allowedTools` in agent JSON
- Check `toolsSettings` for path/command restrictions

## Quick Reference

**Configuration locations:**

```bash
~/.kiro/agents/              # Agent definitions
~/.kiro/settings/mcp.json    # Global MCP servers
~/.kiro/logs/                # Audit logs
~/.dotfiles/etc/kiro-cli/    # Source configs
```

**Common tasks:**

```bash
# Create new agent
vim ~/.dotfiles/etc/kiro-cli/cli-agents/myagent.json
./install/kiro-cli.sh

# View audit logs
tail -f ~/.kiro/logs/aws-audit.jsonl | jq
```

## Reference Documentation

- `references/agent-configuration.md` - Detailed configuration fields and examples
- `references/mcp-servers.md` - MCP server installation and setup
- `references/security.md` - Security patterns and restrictions
