# Security Configuration

## Security Principles

1. **Restrictive by default** - Add permissions as needed
1. **Audit sensitive operations** - AWS, kubectl, etc.
1. **Explicit tool permissions** - No wildcards in production
1. **Path-based restrictions** - Limit file operations
1. **Command restrictions** - Block destructive operations

## Shell Command Restrictions

### Allowed Commands (Safe, Read-Only)

```json
{
  "toolsSettings": {
    "shell": {
      "allowedCommands": [
        "awk .*",
        "cat .*",
        "command -v .*",
        "git branch.*",
        "git diff.*",
        "git log.*",
        "git show.*",
        "git status.*",
        "grep .*",
        "head .*",
        "hostname",
        "ls .*",
        "man .*",
        "pwd",
        "sed .*",
        "sort .*",
        "tail .*",
        "type .*",
        "uniq .*",
        "wc .*",
        "which .*",
        "whoami"
      ]
    }
  }
}
```

### Denied Commands (Destructive)

```json
{
  "toolsSettings": {
    "shell": {
      "deniedCommands": [
        "chmod .*",
        "chown .*",
        "cp /.*",
        "crontab -e",
        "crontab -r",
        "dd .*",
        "docker exec --privileged .*",
        "docker run --privileged .*",
        "fdisk .*",
        "git add.*",
        "git commit.*",
        "init .*",
        "kill -9 .*",
        "killall .*",
        "kubectl apply .*",
        "kubectl create .*",
        "kubectl delete .*",
        "kubectl patch .*",
        "kubectl replace .*",
        "mkfs .*",
        "mount .*",
        "mv /.*",
        "pkill .*",
        "reboot",
        "rm .*",
        "rmdir .*",
        "service .*",
        "shutdown .*",
        "sudo .*",
        "systemctl .*",
        "trash .*",
        "umount .*"
      ]
    }
  }
}
```

## File Operation Restrictions

### Write Permissions

```json
{
  "toolsSettings": {
    "write": {
      "allowedPaths": ["~/projects/**", "~/repositories/**", "~/.dotfiles/**", "./**"],
      "deniedPaths": ["/etc/**", "/usr/**", "/bin/**", "/sbin/**", "/System/**"]
    }
  }
}
```

### Read Permissions

```json
{
  "toolsSettings": {
    "read": {
      "allowedPaths": ["~/projects/**", "~/repositories/**", "~/.dotfiles/**", "./**"],
      "deniedPaths": ["/etc/shadow", "/etc/sudoers", "~/.ssh/id_*"]
    }
  }
}
```

### Grep/Glob Permissions

```json
{
  "toolsSettings": {
    "grep": {
      "allowedPaths": ["~/projects/**", "~/repositories/**", "~/.dotfiles/**", "./**"],
      "deniedPaths": ["/etc/**", "/usr/**", "/bin/**", "/sbin/**", "/System/**"]
    },
    "glob": {
      "allowedPaths": ["~/projects/**", "~/repositories/**", "~/.dotfiles/**", "./**"],
      "deniedPaths": ["/etc/**", "/usr/**", "/bin/**", "/sbin/**", "/System/**"]
    }
  }
}
```

## AWS Restrictions

```json
{
  "toolsSettings": {
    "aws": {
      "allowedServices": [
        "s3",
        "lambda",
        "ec2",
        "ecs",
        "eks",
        "cloudformation",
        "cloudwatch",
        "logs",
        "iam",
        "sts",
        "ssm"
      ],
      "autoAllowReadonly": true
    }
  }
}
```

**`autoAllowReadonly: true`** - Automatically allows read-only operations (describe, list, get)

## Web Fetch Restrictions

```json
{
  "toolsSettings": {
    "web_fetch": {
      "trusted": [
        ".*docs\\.aws\\.amazon\\.com.*",
        ".*github\\.com.*",
        ".*stackoverflow\\.com.*",
        ".*developer\\.mozilla\\.org.*"
      ],
      "blocked": [".*pastebin\\.com.*"]
    }
  }
}
```

**Pattern behavior:**

- `trusted` - Auto-allow without prompting
- `blocked` - Deny (takes precedence over trusted)
- Patterns are regex, automatically anchored

## Subagent Restrictions

```json
{
  "toolsSettings": {
    "subagent": {
      "availableAgents": ["default", "github", "jira"],
      "trustedAgents": ["default"]
    }
  }
}
```

**availableAgents** - Which agents can be spawned **trustedAgents** - Which agents don't require
permission prompt

## Audit Logging

### AWS Operations

```json
{
  "hooks": {
    "preToolUse": [
      {
        "matcher": "use_aws",
        "command": "jq -c '{timestamp: now | strftime(\"%Y-%m-%d %H:%M:%S\"), tool: .tool_name, input: .tool_input}' >> ~/.kiro/logs/aws-audit.jsonl"
      }
    ]
  }
}
```

**View logs:**

```bash
tail -f ~/.kiro/logs/aws-audit.jsonl | jq
```

### Kubernetes Operations

```json
{
  "hooks": {
    "preToolUse": [
      {
        "matcher": "@kubernetes",
        "command": "jq -c '{timestamp: now | strftime(\"%Y-%m-%d %H:%M:%S\"), tool: .tool_name, input: .tool_input}' >> ~/.kiro/logs/kubectl-audit.jsonl"
      }
    ]
  }
}
```

**View logs:**

```bash
tail -f ~/.kiro/logs/kubectl-audit.jsonl | jq
```

### Shell Command Audit

```json
{
  "hooks": {
    "preToolUse": [
      {
        "matcher": "execute_bash",
        "command": "~/.dotfiles/etc/kiro-cli/hooks/audit-shell-commands.sh"
      }
    ]
  }
}
```

## Agent-Specific Security

### Default Agent

**Comprehensive but restricted:**

- Read-only AWS operations
- Read-only Kubernetes operations
- Audit logging for AWS and kubectl
- Shell command restrictions
- File operation restrictions

### GitHub Agent

**GitHub-focused restrictions:**

- No git commits/pushes
- No AWS operations
- No kubectl operations
- Restricted to GitHub-related tools

**Denied commands:**

```json
{
  "deniedCommands": ["aws .*", "git add.*", "git commit.*", "kubectl .*"]
}
```

### JIRA Agent

**JIRA-focused restrictions:**

- No git operations
- No AWS operations
- No kubectl operations
- Restricted to JIRA-related tools

**Denied commands:**

```json
{
  "deniedCommands": [
    "aws .*",
    "git add.*",
    "git commit .*",
    "git merge .*",
    "git push .*",
    "git rebase .*",
    "kubectl .*"
  ]
}
```

## Security Best Practices

1. **Start restrictive** - Add permissions as needed
1. **Audit sensitive operations** - AWS, kubectl, shell commands
1. **Use path restrictions** - Limit file operations to project directories
1. **Block destructive commands** - rm, sudo, git commit, kubectl delete
1. **Auto-allow read-only** - Use `autoAllowReadonly` for AWS
1. **Trust specific domains** - Use `trusted` patterns for web_fetch
1. **Review audit logs** - Regularly check for unexpected operations
1. **Test in safe environment** - Verify restrictions work as expected
1. **Document security model** - In agent prompt or README
1. **Version control configs** - Track security changes

## Common Security Patterns

### Read-Only Agent

```json
{
  "allowedTools": ["fs_read", "grep", "glob", "web_search", "web_fetch"],
  "toolsSettings": {
    "shell": {
      "allowedCommands": ["ls .*", "cat .*", "grep .*"],
      "deniedCommands": [".*"]
    }
  }
}
```

### Project-Scoped Agent

```json
{
  "toolsSettings": {
    "write": {
      "allowedPaths": ["./src/**", "./tests/**"],
      "deniedPaths": ["./**"]
    },
    "shell": {
      "allowedCommands": ["npm test", "npm run lint"]
    }
  }
}
```

### Audit-Everything Agent

```json
{
  "hooks": {
    "preToolUse": [
      {
        "command": "jq -c '{timestamp: now | strftime(\"%Y-%m-%d %H:%M:%S\"), tool: .tool_name, input: .tool_input}' >> ~/.kiro/logs/all-operations.jsonl"
      }
    ]
  }
}
```
