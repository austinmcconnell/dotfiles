# Antidote Plugin Management

## Overview

Antidote is a high-performance Zsh plugin manager that uses static loading for fast startup.

**Key concept:** Generate a static `.zsh_plugins.zsh` file from `.zsh_plugins.txt` manifest.

## Static vs Dynamic Loading

**Static loading (Antidote):**

- Generates `.zsh_plugins.zsh` from manifest
- Static file is sourced at startup (fast)
- Regenerate after changing manifest

**Dynamic loading (Oh My Zsh):**

- Evaluates plugins at every startup (slow)
- No regeneration needed

## Plugin Manifest Format

**Location:** `~/.config/zsh/.zsh_plugins.txt`

**Basic syntax:**

```bash
# Framework plugins
mattmc3/zephyr path:plugins/history
mattmc3/zephyr path:plugins/completion

# External plugins
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting kind:defer

# Deferred loading for performance
olets/zsh-abbr kind:defer
```

## Plugin Loading Strategies

### Immediate Loading (Default)

```bash
zsh-users/zsh-autosuggestions
```

Loads during startup. Use for:

- Completions
- Essential utilities
- Prompts

### Deferred Loading

```bash
zsh-users/zsh-syntax-highlighting kind:defer
```

Loads after prompt appears. Use for:

- Syntax highlighting
- Non-essential utilities
- Heavy plugins

### Path-Specific Loading

```bash
mattmc3/zephyr path:plugins/history
```

Loads specific subdirectory from repo. Use for:

- Framework components
- Monorepo plugins

## Adding New Plugins

### Step 1: Add to Manifest

```bash
vim ~/.config/zsh/.zsh_plugins.txt
```

Add line:

```bash
username/repo-name kind:defer
```

### Step 2: Regenerate Static File

```bash
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
```

### Step 3: Reload Shell

```bash
exec zsh
```

### Step 4: Verify

```bash
antidote list
```

## Plugin Sources

### GitHub (Default)

```bash
zsh-users/zsh-autosuggestions
```

Clones from `https://github.com/zsh-users/zsh-autosuggestions`

### Full URL

```bash
https://github.com/username/repo
```

### Local Path

```bash
/path/to/local/plugin
```

## Common Plugins

### Syntax Highlighting

```bash
zsh-users/zsh-syntax-highlighting kind:defer
```

**Why defer:** Heavy processing, not needed immediately

### Autosuggestions

```bash
zsh-users/zsh-autosuggestions
```

**Why immediate:** Needed for interactive use

### Abbreviations

```bash
olets/zsh-abbr kind:defer
```

**Why defer:** Not needed until first use

### FZF Integration

```bash
junegunn/fzf path:shell kind:defer
```

**Why defer:** Heavy initialization

### Git Utilities

```bash
wfxr/forgit kind:defer
```

**Why defer:** Not needed immediately

## Plugin Configuration

### Before Plugin Loads

In `.zshrc` before sourcing `.zsh_plugins.zsh`:

```bash
# Configure plugin before loading
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Source plugins
source ~/.config/zsh/.zsh_plugins.zsh
```

### After Plugin Loads

In `.zshrc` after sourcing `.zsh_plugins.zsh`:

```bash
# Source plugins first
source ~/.config/zsh/.zsh_plugins.zsh

# Configure after loading
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
```

### In conf.d/

Create topic-specific file:

```bash
# ~/.config/zsh/conf.d/fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

## Managing Plugins

### List Installed Plugins

```bash
antidote list
```

### Update Plugins

```bash
antidote update
```

### Remove Plugin

1. Remove from `.zsh_plugins.txt`
1. Regenerate static file
1. Reload shell

```bash
vim ~/.config/zsh/.zsh_plugins.txt
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
exec zsh
```

### Clean Unused Plugins

Antidote doesn't have a clean command. Manually remove:

```bash
rm -rf ~/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-username-SLASH-repo
```

## Plugin Loading Order

**Order matters:**

```bash
# 1. Framework plugins first
mattmc3/zephyr path:plugins/history
mattmc3/zephyr path:plugins/completion

# 2. Essential plugins
zsh-users/zsh-autosuggestions

# 3. Deferred plugins last
zsh-users/zsh-syntax-highlighting kind:defer
olets/zsh-abbr kind:defer
```

**Why:**

- Framework provides base functionality
- Essential plugins need framework
- Deferred plugins load after prompt

## Troubleshooting

### Plugin Not Loading

**Check manifest syntax:**

```bash
cat ~/.config/zsh/.zsh_plugins.txt
```

**Regenerate static file:**

```bash
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
```

**Verify plugin exists:**

```bash
antidote list
```

**Check for errors:**

```bash
zsh -x 2>&1 | grep plugin-name
```

### Plugin Conflicts

**Disable plugins one by one:**

```bash
# Comment out in .zsh_plugins.txt
# username/problematic-plugin

# Regenerate and test
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
exec zsh
```

### Slow Startup

**Profile to find culprit:**

```bash
ZSH_PROFILE_RC=1 zsh
```

**Defer heavy plugins:**

```bash
# Add kind:defer to slow plugins
heavy-plugin kind:defer
```

## Best Practices

1. **Defer non-essential plugins** - Faster startup
1. **Load framework first** - Provides base functionality
1. **Syntax highlighting last** - Heavy processing
1. **Use path: for monorepos** - Load specific components
1. **Configure before loading** - Set plugin options early
1. **Regenerate after changes** - Static file must be updated
1. **Test incrementally** - Add one plugin at a time
1. **Profile regularly** - Catch performance regressions

## Example Plugin Manifest

```bash
# Framework
mattmc3/zephyr path:plugins/history
mattmc3/zephyr path:plugins/completion
mattmc3/zephyr path:plugins/utility
mattmc3/zephyr path:plugins/confd

# Essential
zsh-users/zsh-autosuggestions
zsh-users/zsh-completions

# Deferred
zsh-users/zsh-syntax-highlighting kind:defer
olets/zsh-abbr kind:defer
wfxr/forgit kind:defer
junegunn/fzf path:shell kind:defer

# Custom
/path/to/local/plugin
```

## Quick Reference

**Add plugin:**

```bash
echo "username/repo kind:defer" >> ~/.config/zsh/.zsh_plugins.txt
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
exec zsh
```

**Remove plugin:**

```bash
vim ~/.config/zsh/.zsh_plugins.txt  # Remove line
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
exec zsh
```

**Update plugins:**

```bash
antidote update
```

**List plugins:**

```bash
antidote list
```
