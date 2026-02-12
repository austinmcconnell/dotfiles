# Amazon Q Integration

> **Note:** Amazon Q has been rebranded as **Kiro CLI**. Configuration directories still
>use `amazon-q` for backward compatibility.

This guide explains how Kiro CLI is integrated into the dotfiles repository and how to configure and
use it effectively.

## Overview

Kiro CLI (formerly Amazon Q) is an AI-powered assistant that helps with coding, answering questions,
and providing recommendations. This dotfiles repository includes configuration and setup for Kiro
CLI to enhance your development workflow.

## Installation

Kiro CLI is installed via the dedicated installation script:

```bash
./install/amazon-q.sh
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
- `etc/kiro-cli/cli-agents/*.json` - CLI agent configurations
- `etc/kiro-cli/profiles/*/context.json` - Profile-specific contexts
- `etc/kiro-cli/global_rules/**/*.md` - Global guidance documents

## Configuration Structure

### CLI Agents

Kiro CLI uses specialized agents for different tasks. Each agent has its own configuration in `etc/kiro-cli/cli-agents/`:

- **default.json** - General development assistant with AWS, database, and infrastructure capabilities
- **jira.json** - JIRA-focused agent for SCRUM and user story management
- **github.json** - GitHub-focused agent for repository and code management

Each agent configuration includes:

- **resources** - Markdown files providing context and guidance to the agent
- **mcpServers** - MCP server integrations (filesystem, git, time, fetch, postgres, jira)
- **allowedTools** - Specific tools the agent can use
- **toolsSettings** - Security restrictions and tool configurations
- **prompt** - Custom system prompt defining the agent's role and behavior

This architecture allows each agent to have specialized knowledge and capabilities while sharing
common infrastructure.

### Profile-Specific Context

Profile-specific contexts allow you to customize Kiro CLI's behavior for different scenarios:

- Development contexts for specific languages or frameworks
- Project-specific information
- Role-specific configurations (e.g., frontend, backend, DevOps)

## Customizing Kiro CLI

### Adding Custom Contexts

To add a custom context:

1. Create a new context file in the appropriate directory:

   ```bash
   touch ~/.dotfiles/etc/kiro-cli/profiles/custom-profile/context.json
   ```

2. Add your context information in JSON format:

   ```json
   {
     "paths": [
       "path/to/custom/documentation.md"
     ]
   }
   ```

### Creating Specialized Profiles

For different development scenarios, you can create specialized profiles:

1. Create a new profile directory:

   ```bash
   mkdir -p ~/.dotfiles/etc/kiro-cli/profiles/python-dev
   ```

2. Add profile-specific context files:

   ```bash
   touch ~/.dotfiles/etc/kiro-cli/profiles/python-dev/context.json
   ```

3. Configure the profile in your settings.json

### Customizing CLI Agents

To customize an existing agent or create a new one:

1. Copy an existing agent configuration:

   ```bash
   cp ~/.dotfiles/etc/kiro-cli/cli-agents/default.json ~/.dotfiles/etc/kiro-cli/cli-agents/custom.json
   ```

2. Modify the `resources`, `prompt`, and `allowedTools` as needed

3. Use the custom agent:

   ```bash
   kiro-cli chat --agent custom
   ```

## Using Kiro CLI Effectively

### Command Line Integration

Kiro CLI can be used directly from the command line:

```bash
kiro-cli chat                           # Start interactive chat with default agent
kiro-cli chat --agent jira              # Use JIRA agent
kiro-cli chat --agent github            # Use GitHub agent
q "How do I create a virtual environment in Python?"  # Legacy wrapper
```

### IDE Integration

Kiro CLI integrates with various IDEs:

- VS Code: Install the Kiro CLI extension
- JetBrains IDEs: Install the Kiro CLI plugin
- Vim/Neovim: Configure through the appropriate plugin

### Best Practices

1. **Be Specific**: Provide clear, specific questions to get the best answers
2. **Use Context**: Reference specific files or code when asking questions
3. **Choose the Right Agent**: Use specialized agents (jira, github) for domain-specific tasks
4. **Iterate**: Refine your questions based on the responses
5. **Verify**: Always verify generated code or suggestions before implementing

## Troubleshooting

If you encounter issues with Kiro CLI:

1. Check that the configuration directories exist
2. Verify that the symbolic links are correctly established
3. Restart Kiro CLI after making configuration changes
4. Check the Kiro CLI logs for error messages

## Advanced Configuration

### Custom Commands

You can create custom commands for Kiro CLI by adding them to your shell configuration:

```bash
# Example custom command for generating unit tests
function q-test() {
  kiro-cli chat "Generate unit tests for the following code: $(cat $1)"
}
```

### Integration with Other Tools

Kiro CLI can be integrated with other development tools:

- Git hooks for pre-commit code reviews
- CI/CD pipelines for automated code analysis
- Documentation generation workflows

## Resources

- [Kiro CLI Documentation](https://kiro.dev/docs/cli/)
- [AWS Documentation](https://aws.amazon.com/)
