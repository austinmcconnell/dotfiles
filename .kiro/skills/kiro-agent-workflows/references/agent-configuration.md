# Agent Configuration Reference

## Configuration File Structure

**Location:** `~/.kiro/agents/` (symlinked from `~/.dotfiles/etc/kiro-cli/cli-agents/`)

**Files:**

```shell
~/.kiro/agents/
├── default.json
├── default-prompt.md
├── github.json
├── github-prompt.md
├── jira.json
└── jira-prompt.md
```

## Configuration Fields

### Core Fields

**name** - Agent identifier

```json
{
  "name": "myagent"
}
```

**description** - What the agent does

```json
{
  "description": "Agent for specific task"
}
```

**prompt** - System prompt (file:// reference)

```json
{
  "prompt": "file://./myagent-prompt.md"
}
```

### Tool Configuration

**tools** - Available tools (usually all)

```json
{
  "tools": ["*"]
}
```

**allowedTools** - Tools that don't require permission

```json
{
  "allowedTools": ["fs_read", "grep", "glob", "web_search", "web_fetch", "use_subagent"]
}
```

**toolsSettings** - Tool-specific configuration

```json
{
  "toolsSettings": {
    "shell": {
      "allowedCommands": ["git status.*", "ls .*"],
      "deniedCommands": ["rm .*", "sudo .*"]
    },
    "write": {
      "allowedPaths": ["~/projects/**"],
      "deniedPaths": ["/etc/**", "/usr/**"]
    },
    "aws": {
      "allowedServices": ["s3", "lambda", "ec2"],
      "autoAllowReadonly": true
    },
    "subagent": {
      "availableAgents": ["default", "github", "jira"],
      "trustedAgents": ["default"]
    },
    "web_fetch": {
      "trusted": [".*github\\.com.*"],
      "blocked": [".*pastebin\\.com.*"]
    }
  }
}
```

### Resources

**resources** - Context files and skills

```json
{
  "resources": [
    "file://AGENTS.md",
    "file://README.md",
    "file://.kiro/steering/**/*.md",
    "skill://.kiro/skills/**/SKILL.md",
    "skill://~/.kiro/skills/**/SKILL.md"
  ]
}
```

### MCP Servers

**mcpServers** - Agent-specific MCP servers

```json
{
  "mcpServers": {
    "github": {
      "command": "github-mcp-server",
      "args": ["stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}"
      },
      "timeout": 120000
    }
  }
}
```

**includeMcpJson** - Include global MCP servers

```json
{
  "includeMcpJson": true
}
```

### Hooks

**hooks** - Commands run at specific triggers

```json
{
  "hooks": {
    "agentSpawn": [
      {
        "command": "git status --short --branch 2>/dev/null || echo 'Not a git repository'"
      }
    ],
    "preToolUse": [
      {
        "matcher": "use_aws",
        "command": "jq -c '{timestamp: now | strftime(\"%Y-%m-%d %H:%M:%S\"), tool: .tool_name, input: .tool_input}' >> ~/.kiro/logs/aws-audit.jsonl"
      }
    ]
  }
}
```

## Complete Example

```json
{
  "name": "myagent",
  "description": "Agent for specific task",
  "prompt": "file://./myagent-prompt.md",
  "tools": ["*"],
  "allowedTools": ["fs_read", "grep", "glob", "web_search", "web_fetch"],
  "toolsSettings": {
    "shell": {
      "allowedCommands": ["ls .*", "cat .*"],
      "deniedCommands": ["rm .*", "sudo .*"]
    },
    "write": {
      "allowedPaths": ["~/projects/**"],
      "deniedPaths": ["/etc/**"]
    }
  },
  "resources": ["file://AGENTS.md", "file://README.md", "skill://.kiro/skills/**/SKILL.md"],
  "includeMcpJson": true,
  "hooks": {
    "agentSpawn": [
      {
        "command": "git status"
      }
    ]
  }
}
```

## Prompt File Example

`myagent-prompt.md`:

```markdown
# My Agent

You are a specialized agent for [specific task].

## Your Role

[Describe what this agent does]

## Guidelines

- [Guideline 1]
- [Guideline 2]

## Restrictions

- [Restriction 1]
- [Restriction 2]
```

## Creating a New Agent

Step 1: Create agent JSON

`~/.dotfiles/etc/kiro-cli/cli-agents/myagent.json`

Step 2: Create prompt file

`~/.dotfiles/etc/kiro-cli/cli-agents/myagent-prompt.md`

Step 3: Link to ~/.kiro/agents/

```bash
./install/kiro-cli.sh
```

### Step 4: Test

```bash
kiro-cli chat --agent myagent
```

## Agent-Specific Features

### Default Agent

- Comprehensive tool access
- AWS operations (read-only)
- Kubernetes operations (read-only)
- Audit logging for AWS and kubectl
- Shell command restrictions

### GitHub Agent

- GitHub MCP server integration
- Read-only GitHub operations
- Time zone conversion (America/Chicago)
- Restricted shell commands (no git commits)

### JIRA Agent

- JIRA MCP server integration
- Read-only JIRA operations
- Time zone conversion (America/Chicago)
- Restricted shell commands (no git operations)
