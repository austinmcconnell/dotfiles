# AI Agent Guidelines Configuration

This document explains how the global AI agent guidelines (`agents.md`) are configured and used
across different AI development tools.

## Overview

The `agents.md` file provides comprehensive guidelines for AI agents working across all development
tools and projects. These guidelines ensure consistent behavior, security, and quality across all
AI-assisted development workflows.

**Location:** `~/.dotfiles/etc/ai-prompts/agents.md`

## Tool-Specific Configuration

### Amazon Q CLI

The `agents.md` file is automatically included in all Amazon Q agent configurations via the
`resources` array. This means all Amazon Q agents (default, github, jira) will have access to these
guidelines.

**Configuration:** The file is referenced in:

- `etc/amazon-q/cli-agents/default.json`
- `etc/amazon-q/cli-agents/github.json`
- `etc/amazon-q/cli-agents/jira.json`

**How it works:** Amazon Q agents read the guidelines from the resources array and use them to
guide their behavior when responding to prompts.

### Cursor IDE

Cursor IDE uses a rule-based system for configuring AI behavior. The `agents.md` guidelines are
made available to Cursor by symlinking directly to the rules directory.

**Configuration:**

- Source file: `etc/ai-prompts/agents.md`
- Symlinked to: `~/.config/cursor/rules/agents.mdc` (XDG-compliant)
- Also linked to: `~/.cursor/rules/agents.mdc` (legacy location)

**Installation:** Run `./install/cursor.sh` to set up Cursor configuration.

**How it works:** Cursor automatically reads all `.mdc` files in the `rules/` directory. By
symlinking `agents.md` as `agents.mdc`, Cursor loads the full guidelines content directly.

### Codex CLI

Codex CLI looks for an `AGENTS.md` file in the **project root** directory. Since this is
per-project, you'll need to create a symlink or copy the file for each project where you want to
use it.

#### Option 1: Symlink (Recommended)

```bash
# In your project root
ln -s ~/.dotfiles/etc/ai-prompts/agents.md AGENTS.md
```

#### Option 2: Copy

```bash
# In your project root
cp ~/.dotfiles/etc/ai-prompts/agents.md AGENTS.md
```

**Option 3: Helper Script**
You can create a helper script to automatically set this up:

```bash
#!/bin/bash
# Add to your dotfiles bin/ directory
ln -sf "$HOME/.dotfiles/etc/ai-prompts/agents.md" "$(pwd)/AGENTS.md"
echo "✓ Linked agents.md to project root as AGENTS.md"
```

**How it works:** Codex automatically detects and uses `AGENTS.md` when present in the project root directory.

## Installation

The configuration is set up automatically when you run the installation scripts:

```bash
# Install Amazon Q configuration (includes agents.md in resources)
./install/amazon-q.sh

# Install Cursor configuration (sets up rules)
./install/cursor.sh
```

Or run the main installation script which includes all components:

```bash
./install.sh
```

## Customization

### Project-Specific Guidelines

You can extend the global guidelines with project-specific rules:

1. **For Amazon Q:** Add project-specific rules to `.amazonq/rules/` directory in your project
2. **For Cursor:** Add project-specific rules to `.cursor/rules/` directory in your project
3. **For Codex:** Create a project-specific `AGENTS.md` that references or extends the global guidelines

### Updating Global Guidelines

To update the global guidelines:

1. Edit `~/.dotfiles/etc/ai-prompts/agents.md`
2. Commit and push changes to your dotfiles repository
3. The changes will automatically be available to:
   - Amazon Q (via resources array)
   - Cursor (via rule file reference)
   - Codex (if symlinked in projects)

## Guidelines Content

The `agents.md` file includes comprehensive guidelines for:

- **Security First** - Never execute destructive commands without confirmation
- **Code Quality** - Run pre-commit hooks and test suites
- **Workflow Integration** - Respect project structure and conventions
- **Filesystem Operations** - Best practices for file searches and operations
- **Git Operations** - Safe practices for version control
- **Testing Workflow** - Automated testing after code changes
- **Code Review** - Guidelines for providing feedback
- **Error Handling** - Best practices for error reporting
- **Performance** - Optimization considerations
- **Communication** - User interaction best practices

## Verification

### Amazon Q

To verify Amazon Q is using the guidelines, check that the agents have the file in their resources:

```bash
q agents list
q agents show default
# Check the "resources" array includes the agents.md file
```

### Cursor

To verify Cursor is using the guidelines:

1. Open Cursor IDE
2. Check that `~/.config/cursor/rules/agents.mdc` exists
3. The rule should reference the agents.md file

### Codex

To verify Codex is using the guidelines:

1. Navigate to a project root
2. Check that `AGENTS.md` exists (symlink or copy)
3. Codex will automatically detect and use it

## Troubleshooting

### Amazon Q not using guidelines

- Verify the agents.json files have `agents.md` in the resources array
- Check that the file path is correct: `file://~/.dotfiles/etc/ai-prompts/agents.md`
- Re-run `./install/amazon-q.sh` to update configurations

### Cursor not using guidelines

- Verify `~/.config/cursor/rules/agents.mdc` exists and is a symlink to `agents.md`
- Check that the symlink target exists: `ls -la ~/.config/cursor/rules/agents.mdc`
- Re-run `./install/cursor.sh` to update configuration
- Restart Cursor IDE

### Codex not using guidelines

- Verify `AGENTS.md` exists in the project root
- Check that the file is readable
- Ensure you're running Codex from the project root directory

## Best Practices

1. **Keep guidelines updated** - Regularly review and update `agents.md` as your workflows evolve
2. **Version control** - All changes to guidelines are tracked in your dotfiles repository
3. **Project-specific extensions** - Use project-specific rules to extend global guidelines
4. **Consistency** - Ensure all tools reference the same source of truth for guidelines

## Related Documentation

- [Amazon Q Integration](../docs/AmazonQIntegration.md)
- [AI Prompt Management](../etc/ai-prompts/README.md)
- [Customization Guide](../docs/CustomizationGuide.md)
