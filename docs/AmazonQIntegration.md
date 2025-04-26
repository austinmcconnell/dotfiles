# Amazon Q Integration

This guide explains how Amazon Q is integrated into the dotfiles repository and how to configure and
use it effectively.

## Overview

Amazon Q is an AI-powered assistant that helps with coding, answering questions, and providing
recommendations. This dotfiles repository includes configuration and setup for Amazon Q to enhance your
development workflow.

## Installation

Amazon Q is installed via the dedicated installation script:

```bash
./install/amazon-q.sh
```

This script:

1. Installs the Amazon Q cask using Homebrew
2. Creates necessary configuration directories
3. Links configuration files from the dotfiles repository
4. Installs Amazon Q integrations (like SSH)

## Configuration Files

The configuration files are stored in:

- `etc/amazon-q/settings.json` - Application settings
- `etc/amazon-q/global_context.json` - Contexts which apply to all profiles
- `etc/amazon-q/profiles/default/context.json` - Contexts which apply only to the default profile

## Configuration Structure

### Global Context

The global context provides Amazon Q with information about your environment that applies across all
profiles.

This typically includes:

- Repository structure information
- Common development patterns
- Standard tools and frameworks used

### Profile-Specific Context

Profile-specific contexts allow you to customize Amazon Q's behavior for different scenarios:

- Development contexts for specific languages or frameworks
- Project-specific information
- Role-specific configurations (e.g., frontend, backend, DevOps)

## Customizing Amazon Q

### Adding Custom Contexts

To add a custom context:

1. Create a new context file in the appropriate directory:

   ```bash
   touch ~/.dotfiles/etc/amazon-q/profiles/custom-profile/context.json
   ```

2. Add your context information in JSON format:

   ```json
   {
     "name": "Custom Development Context",
     "description": "Information about my custom development environment",
     "content": "This is a custom development environment for XYZ project..."
   }
   ```

### Creating Specialized Profiles

For different development scenarios, you can create specialized profiles:

1. Create a new profile directory:

   ```bash
   mkdir -p ~/.dotfiles/etc/amazon-q/profiles/python-dev
   ```

2. Add profile-specific context files:

   ```bash
   touch ~/.dotfiles/etc/amazon-q/profiles/python-dev/context.json
   ```

3. Configure the profile in your settings.json

## Using Amazon Q Effectively

### Command Line Integration

Amazon Q can be used directly from the command line:

```bash
q "How do I create a virtual environment in Python?"
```

### IDE Integration

Amazon Q integrates with various IDEs:

- VS Code: Install the Amazon Q extension
- JetBrains IDEs: Install the Amazon Q plugin
- Vim/Neovim: Configure through the appropriate plugin

### Best Practices

1. **Be Specific**: Provide clear, specific questions to get the best answers
2. **Use Context**: Reference specific files or code when asking questions
3. **Iterate**: Refine your questions based on the responses
4. **Verify**: Always verify generated code or suggestions before implementing

## Troubleshooting

If you encounter issues with Amazon Q:

1. Check that the configuration directories exist
2. Verify that the symbolic links are correctly established
3. Restart Amazon Q after making configuration changes
4. Check the Amazon Q logs for error messages

## Advanced Configuration

### Custom Commands

You can create custom commands for Amazon Q by adding them to your shell configuration:

```bash
# Example custom command for generating unit tests
function q-test() {
  q "Generate unit tests for the following code: $(cat $1)"
}
```

### Integration with Other Tools

Amazon Q can be integrated with other development tools:

- Git hooks for pre-commit code reviews
- CI/CD pipelines for automated code analysis
- Documentation generation workflows

## Resources

- [Amazon Q Documentation](https://aws.amazon.com/q/)
- [Amazon Q CLI Reference](https://docs.aws.amazon.com/amazonq/latest/cli-reference/)
