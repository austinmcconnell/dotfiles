---
name: zsh-deep-dive
description:
  Deep technical guide for Zsh configuration using Zephyr framework and Antidote plugin manager. Use
  when adding plugins, debugging startup performance, creating custom functions, or troubleshooting
  shell configuration issues.
---

# Zsh Configuration Deep Dive

## Zephyr Framework Architecture

**What is Zephyr?**

- Lightweight, modular Zsh framework
- Provides core functionality: history, completion, utilities
- Designed for performance and maintainability
- No heavy abstractions like Oh My Zsh

**Core Components:**

- `zephyr/history` - Shared history across sessions
- `zephyr/completion` - Intelligent tab completion system
- `zephyr/utility` - Common shell utilities
- `zephyr/confd` - Auto-loads files from `conf.d/` directory

## Configuration Loading Order

**1. `.zshenv` (ALL shells)**

- Environment variables
- XDG directory setup
- PATH configuration
- Runs for every shell (interactive, non-interactive, login, non-login)

**2. `.zprofile` (Login shells)**

- Login-specific environment setup
- Runs once per login session

**3. `.zshrc` (Interactive shells)**

- Plugin loading via Antidote
- Zephyr framework initialization
- conf.d/ files loaded by zephyr/confd
- Interactive shell configuration

**4. `.zlogin` (Login shells, after .zshrc)**

- Post-login initialization
- Runs after .zshrc for login shells

## Adding Plugins

See `references/antidote-plugins.md` for detailed plugin management.

**Quick steps:**

1. Add to `.zsh_plugins.txt`
1. Regenerate static file:
   `antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh`
1. Reload shell: `exec zsh`

## Modular Configuration (conf.d/)

**How it works:**

- Zephyr's `confd` plugin auto-loads `*.zsh` files from `conf.d/`
- Files loaded in alphabetical order
- Platform-specific: `*.zsh-darwin` (macOS), `*.zsh-linux` (Linux)

**Creating new conf.d file:**

```bash
cat > ~/.config/zsh/conf.d/kubernetes.zsh <<'EOF'
# Kubernetes aliases and functions
alias k='kubectl'
alias kgp='kubectl get pods'
EOF

exec zsh
```

## Custom Functions

See `references/custom-functions.md` for detailed function patterns.

**Location:** `~/.config/zsh/functions/`

**Quick example:**

```bash
cat > ~/.config/zsh/functions/git-cleanup <<'EOF'
# Remove merged branches
git branch --merged | grep -v "\*" | grep -v "main\|master" | xargs -n 1 git branch -d
EOF

chmod +x ~/.config/zsh/functions/git-cleanup
```

## Debugging Slow Startup

See `references/performance.md` for detailed optimization strategies.

**Profile startup:**

```bash
ZSH_PROFILE_RC=1 zsh
```

**Quick fixes:**

- Defer non-essential plugins: Add `kind:defer` to `.zsh_plugins.txt`
- Move expensive operations from `.zshenv` to `.zshrc`
- Use lazy loading for version managers

## Abbreviations (zsh-abbr)

**Location:** `~/.config/zsh/zsh-abbr/user-abbreviations`

**Adding abbreviations:**

```bash
abbr gco="git checkout"
abbr dps="docker ps"
```

**Abbreviation vs Alias:**

- Abbreviation: Expands before execution, visible in history
- Alias: Substituted at execution, hidden in history

## Completions

**Custom completions location:** `~/.config/zsh/completions/`

**Rebuild completion cache:**

```bash
rm -f ~/.cache/zsh/zcompcache/.zcompdump*
exec zsh
```

## Platform-Specific Configuration

**Conditional loading:**

```bash
if [[ "$OSTYPE" == darwin* ]]; then
  # macOS-specific
elif [[ "$OSTYPE" == linux* ]]; then
  # Linux-specific
fi
```

**File suffix approach:**

```bash
touch ~/.config/zsh/conf.d/macos.zsh-darwin  # Only loads on macOS
touch ~/.config/zsh/conf.d/linux.zsh-linux   # Only loads on Linux
```

## Troubleshooting

**Plugin not loading:**

1. Check `.zsh_plugins.txt` syntax
1. Regenerate static file
1. Verify plugin exists: `antidote list`

**Completion not working:**

1. Rebuild cache: `rm -f ~/.cache/zsh/zcompcache/.zcompdump*`
1. Check fpath: `echo $fpath`
1. Verify completion file starts with underscore

**Function not found:**

1. Verify file in `~/.config/zsh/functions/`
1. Check fpath includes functions directory
1. Reload: `exec zsh`

## Best Practices

1. **Keep .zshenv minimal** - Only essential environment variables
1. **Defer non-essential plugins** - Faster startup
1. **Use conf.d for organization** - Topic-based files
1. **Autoload custom functions** - Lazy loading
1. **Profile before optimizing** - Measure first
1. **Platform-specific suffixes** - Clean conditional logic
1. **Abbreviations over aliases** - Better history

## Quick Reference

**Configuration files:**

```bash
~/.config/zsh/.zshrc           # Main config
~/.config/zsh/.zsh_plugins.txt # Plugin manifest
~/.config/zsh/conf.d/          # Modular configs
~/.config/zsh/functions/       # Custom functions
```

**Common commands:**

```bash
exec zsh                       # Reload shell
ZSH_PROFILE_RC=1 zsh          # Profile startup
antidote list                  # List plugins
abbr                          # List abbreviations
```

## Reference Documentation

- `references/antidote-plugins.md` - Plugin management and loading strategies
- `references/custom-functions.md` - Function creation patterns and examples
- `references/performance.md` - Startup optimization and profiling
