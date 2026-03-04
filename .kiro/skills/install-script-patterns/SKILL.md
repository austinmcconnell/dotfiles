---
name: install-script-patterns
description: Guide for writing dotfiles install scripts with idempotency patterns and utility functions. Use when creating new install scripts, troubleshooting installation issues, or understanding the install system architecture.
---

# Install Script Patterns

## Architecture Overview

**Modular installation system:**

- `install.sh` - Main orchestrator, sources individual scripts
- `install/utils.sh` - Shared utility functions
- `install/{tool}.sh` - Individual tool installation scripts
- Each script is idempotent (safe to run multiple times)

**Philosophy:**

- One script per tool/environment
- Symlinks from `etc/` to home directory
- Check before installing (don't reinstall unnecessarily)
- Clear status messages for user feedback

## Script Template

```bash
#!/bin/bash

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

print_header "Installing Tool Name"

init_brew_cache
install_if_needed "package-name" "formula"

mkdir -p "$HOME/.config/tool"
ln -sfv "$DOTFILES_DIR/etc/tool/config.conf" "$HOME/.config/tool/config.conf"

echo "✅ Tool Name installation complete"
```

## Core Patterns

### Idempotency

**Key principle:** Scripts must be safe to run multiple times.

**Directory creation:**

```bash
mkdir -p "$HOME/.config/tool"  # No error if exists
```

**Symlink creation:**

```bash
ln -sfv "$SOURCE" "$TARGET"  # Force overwrites existing
```

**Conditional installation:**

```bash
install_if_needed "package"  # Checks before installing
```

### Error Handling

```bash
set -euo pipefail  # Exit on error, undefined variable, pipe failure
```

### Platform-Specific

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS-specific
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux-specific
fi
```

## Utility Functions

See `references/utility-functions.md` for detailed function reference.

**Quick reference:**

- `init_brew_cache()` - Initialize Homebrew cache
- `install_if_needed <package> [type] [install_type]` - Install package if needed
- `tap_if_needed <tap>` - Add Homebrew tap if needed
- `print_header <message>` - Print formatted header
- `is_package_installed <package> [type]` - Check if package installed
- `is_package_outdated <package> [type]` - Check if package outdated

## Common Patterns

### Installing Multiple Packages

```bash
PACKAGES=("git" "vim" "tmux" "fzf")
for package in "${PACKAGES[@]}"; do
    install_if_needed "$package"
done
```

### Linking Config Files

```bash
if [ -d "$DOTFILES_DIR/etc/tool" ]; then
    for config_file in "$DOTFILES_DIR/etc/tool"/*; do
        if [ -f "$config_file" ]; then
            filename=$(basename "$config_file")
            ln -sfv "$config_file" "$HOME/.config/tool/$filename"
        fi
    done
fi
```

### Work vs Personal

```bash
install_if_needed "slack" "cask" "work"      # Work only
install_if_needed "spotify" "cask" "personal" # Personal only
```

## Complete Example

See `references/examples.md` for complete example scripts.

## Best Practices

1. **One tool per script** - Easy to maintain
2. **Use utility functions** - Don't reinvent
3. **Initialize brew cache** - Faster execution
4. **Clear status messages** - User feedback
5. **Check before installing** - Idempotency
6. **Force symlinks** - `ln -sf`
7. **Create parent directories** - `mkdir -p`
8. **Set strict mode** - `set -euo pipefail`
9. **Document what script does** - Header comment
10. **Test twice** - Verify idempotency

## Troubleshooting

**Script fails on first run:**

- Check `set -euo pipefail` - may be too strict
- Add error handling for optional steps

**Symlinks not created:**

- Check source path exists
- Verify target directory exists
- Use `-f` flag to force overwrite

**Brew cache issues:**

- Delete cache: `rm -rf ~/.cache/dotfiles/brew_cache`
- Run `init_brew_cache` again

## Quick Reference

**Create new install script:**

```bash
vim install/tool.sh
# Use template above
chmod +x install/tool.sh
./install/tool.sh
```

**Test idempotency:**

```bash
./install/tool.sh  # Run twice
./install/tool.sh  # Should not error
```

**Reference Documentation:**

- `references/utility-functions.md` - Detailed function reference
- `references/examples.md` - Complete example scripts
