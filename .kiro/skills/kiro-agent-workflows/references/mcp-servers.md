# MCP Server Configuration

## Overview

MCP (Model Context Protocol) servers extend agent capabilities with specialized tools.

**Two configuration locations:**

1. **Global:** `~/.kiro/settings/mcp.json` (all agents)
1. **Agent-specific:** In agent JSON `mcpServers` field

## Global MCP Configuration

`~/.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem"],
      "disabled": false
    },
    "git": {
      "command": "python",
      "args": ["-m", "mcp_server_git"],
      "disabled": false
    },
    "time": {
      "command": "python",
      "args": ["-m", "mcp_server_time", "--local-timezone=America/Chicago"],
      "disabled": false
    },
    "fetch": {
      "command": "python",
      "args": ["-m", "mcp_server_fetch"],
      "disabled": false
    }
  }
}
```

## Agent-Specific MCP Configuration

In agent JSON:

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
    },
    "jira": {
      "command": "npx",
      "args": ["@aashari/mcp-server-atlassian-jira"],
      "timeout": 120000
    }
  },
  "includeMcpJson": true
}
```

**`includeMcpJson: true`** - Includes global MCP servers + agent-specific

## Installing MCP Servers

### Node.js Servers

```bash
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @aashari/mcp-server-atlassian-jira
npm install -g kubernetes-mcp-server
npm install -g enhanced-postgres-mcp-server
```

### Python Servers

```bash
pip install mcp-server-git
pip install mcp-server-time
pip install mcp-server-fetch
```

### Go Servers (Build from Source)

**GitHub MCP Server:**

```bash
go install github.com/github/github-mcp-server/cmd/github-mcp-server@latest
```

## Environment Variables

### Setting in Agent JSON

```json
{
  "mcpServers": {
    "github": {
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}"
      }
    },
    "jira": {
      "env": {
        "JIRA_URL": "${JIRA_URL}",
        "JIRA_EMAIL": "${JIRA_EMAIL}",
        "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
      }
    }
  }
}
```

### Setting in Shell Environment

`~/.extra/.env` or `~/.zshrc`:

```bash
export GITHUB_PAT="ghp_xxxxxxxxxxxx"
export JIRA_URL="https://company.atlassian.net"
export JIRA_EMAIL="user@company.com"
export JIRA_API_TOKEN="xxxxxxxxxxxx"
```

## MCP Server Configuration Fields

**command** (required) - Command to execute

```json
{
  "command": "github-mcp-server"
}
```

**args** (optional) - Command arguments

```json
{
  "args": ["stdio", "--verbose"]
}
```

**env** (optional) - Environment variables

```json
{
  "env": {
    "API_KEY": "${MY_API_KEY}"
  }
}
```

**timeout** (optional) - Request timeout in milliseconds

```json
{
  "timeout": 120000
}
```

**disabled** (optional) - Disable server

```json
{
  "disabled": true
}
```

## Current MCP Servers

### Filesystem Server

**Purpose:** File operations (read, write, list, search)

**Installation:**

```bash
npm install -g @modelcontextprotocol/server-filesystem
```

**Configuration:**

```json
{
  "filesystem": {
    "command": "npx",
    "args": ["@modelcontextprotocol/server-filesystem"]
  }
}
```

### Git Server

**Purpose:** Git operations (status, log, diff, branch)

**Installation:**

```bash
pip install mcp-server-git
```

**Configuration:**

```json
{
  "git": {
    "command": "python",
    "args": ["-m", "mcp_server_git"]
  }
}
```

### Time Server

**Purpose:** Time zone conversion, current time

**Installation:**

```bash
pip install mcp-server-time
```

**Configuration:**

```json
{
  "time": {
    "command": "python",
    "args": ["-m", "mcp_server_time", "--local-timezone=America/Chicago"]
  }
}
```

### Fetch Server

**Purpose:** HTTP requests, web scraping

**Installation:**

```bash
pip install mcp-server-fetch
```

**Configuration:**

```json
{
  "fetch": {
    "command": "python",
    "args": ["-m", "mcp_server_fetch"]
  }
}
```

### GitHub Server

**Purpose:** GitHub API operations (repos, issues, PRs, releases)

**Installation:**

```bash
go install github.com/github/github-mcp-server/cmd/github-mcp-server@latest
```

**Configuration:**

```json
{
  "github": {
    "command": "github-mcp-server",
    "args": ["stdio"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}"
    }
  }
}
```

### JIRA Server

**Purpose:** JIRA operations (issues, projects, sprints, worklogs)

**Installation:**

```bash
npm install -g @aashari/mcp-server-atlassian-jira
```

**Configuration:**

```json
{
  "jira": {
    "command": "npx",
    "args": ["@aashari/mcp-server-atlassian-jira"],
    "env": {
      "JIRA_URL": "${JIRA_URL}",
      "JIRA_EMAIL": "${JIRA_EMAIL}",
      "JIRA_API_TOKEN": "${JIRA_API_TOKEN}"
    }
  }
}
```

## Troubleshooting

### Server Not Working

**Check server status in chat:**

```bash
/tools
```

**Test server manually:**

```bash
# Node.js server
npx @modelcontextprotocol/server-filesystem

# Python server
python -m mcp_server_git

# Go server
github-mcp-server --help
```

### Environment Variables Not Set

**Check variables:**

```bash
echo $GITHUB_PAT
echo $JIRA_URL
```

**Source environment file:**

```bash
source ~/.extra/.env
```

### Server Timeout

**Increase timeout in config:**

```json
{
  "timeout": 300000
}
```

### Server Disabled

**Check disabled flag:**

```json
{
  "disabled": false
}
```

## Best Practices

1. **Global for common tools** - filesystem, git, time, fetch
1. **Agent-specific for specialized** - github, jira, kubernetes
1. **Use environment variables** - Never hardcode credentials
1. **Set reasonable timeouts** - Default 120000ms (2 minutes)
1. **Test servers individually** - Verify before adding to agent
1. **Version control configs** - Track MCP server versions
1. **Document required env vars** - In agent prompt or README
