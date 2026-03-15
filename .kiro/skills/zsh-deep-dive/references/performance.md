# Zsh Startup Performance

## Profiling Startup Time

### Enable Profiling

```bash
ZSH_PROFILE_RC=1 zsh
```

Shows timing for each operation during startup.

### Analyze Output

Look for:

- Operations taking > 100ms
- Repeated operations
- Expensive plugin loads
- Synchronous operations

## Common Performance Issues

### 1. Non-Deferred Plugins

**Problem:** Heavy plugins loading synchronously

**Solution:** Add `kind:defer` to `.zsh_plugins.txt`

**Before:**

```bash
zsh-users/zsh-syntax-highlighting
```

**After:**

```bash
zsh-users/zsh-syntax-highlighting kind:defer
```

**Impact:** 50-200ms improvement per plugin

### 2. Expensive Operations in .zshenv

**Problem:** `.zshenv` runs for ALL shells (interactive, non-interactive, login, non-login)

**Solution:** Move to `.zshrc` (only interactive shells)

**Bad (.zshenv):**

```bash
eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(nodenv init -)"
```

**Good (.zshrc):**

```bash
if [[ -o interactive ]]; then
  eval "$(rbenv init -)"
  eval "$(pyenv init -)"
  eval "$(nodenv init -)"
fi
```

**Impact:** 100-300ms improvement

### 3. Synchronous Plugin Loading

**Problem:** Plugins loading one at a time

**Solution:** Use Antidote's static loading (already configured)

**Impact:** 50-100ms improvement

### 4. Unoptimized Completions

**Problem:** Completion system rebuilding on every startup

**Solution:** Cache completions (already configured)

```bash
# In .zstyles
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
```

**Impact:** 50-150ms improvement

## Optimization Strategies

### Defer Non-Essential Plugins

**Identify candidates:**

- Syntax highlighting
- Abbreviations
- FZF integration
- Git utilities

**Update `.zsh_plugins.txt`:**

```bash
# Essential (load immediately)
zsh-users/zsh-autosuggestions
zsh-users/zsh-completions

# Non-essential (defer)
zsh-users/zsh-syntax-highlighting kind:defer
olets/zsh-abbr kind:defer
wfxr/forgit kind:defer
junegunn/fzf path:shell kind:defer
```

**Regenerate:**

```bash
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
```

### Lazy-Load Version Managers

**Problem:** Version managers slow startup

**Solution:** Lazy-load on first use

**pyenv example:**

```bash
# Instead of: eval "$(pyenv init -)"
pyenv() {
  unfunction pyenv
  eval "$(command pyenv init -)"
  pyenv "$@"
}
```

**rbenv example:**

```bash
rbenv() {
  unfunction rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}
```

**nodenv example:**

```bash
nodenv() {
  unfunction nodenv
  eval "$(command nodenv init -)"
  nodenv "$@"
}
```

**Impact:** 100-200ms improvement per version manager

### Move Expensive Operations

**From .zshenv to .zshrc:**

```bash
# .zshenv - Only essential environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# .zshrc - Everything else
eval "$(pyenv init -)"
eval "$(rbenv init -)"
```

### Optimize PATH

**Problem:** Duplicate PATH entries

**Solution:** Use typeset -U

```bash
# In .zshenv
typeset -U path
path=(
  $HOME/.local/bin
  $HOME/bin
  /usr/local/bin
  $path
)
```

**Impact:** 10-20ms improvement

### Cache Expensive Commands

**Problem:** Commands evaluated on every startup

**Solution:** Cache results

**Example:**

```bash
# Cache brew prefix
if [[ -z "$HOMEBREW_PREFIX" ]]; then
  export HOMEBREW_PREFIX=$(brew --prefix)
fi
```

## Measuring Improvements

### Before Optimization

```bash
ZSH_PROFILE_RC=1 zsh 2>&1 | tail -1
# Example: 0.450s
```

### After Optimization

```bash
ZSH_PROFILE_RC=1 zsh 2>&1 | tail -1
# Example: 0.150s
```

### Calculate Improvement

```text
Improvement = (Before - After) / Before * 100
Example: (450ms - 150ms) / 450ms * 100 = 66% faster
```

## Startup Time Targets

**Excellent:** < 100ms **Good:** 100-200ms **Acceptable:** 200-300ms **Needs optimization:** > 300ms

## Debugging Slow Startup

### Step 1: Profile

```bash
ZSH_PROFILE_RC=1 zsh
```

### Step 2: Identify Culprits

Look for operations > 100ms

### Step 3: Defer or Optimize

- Defer plugins: Add `kind:defer`
- Lazy-load: Wrap in function
- Move to .zshrc: Remove from .zshenv
- Cache: Store expensive results

### Step 4: Measure

```bash
ZSH_PROFILE_RC=1 zsh 2>&1 | tail -1
```

### Step 5: Repeat

Continue until startup < 200ms

## Advanced Optimization

### Compile Zsh Files

```bash
# Compile .zshrc
zcompile ~/.zshrc

# Compile plugins
zcompile ~/.config/zsh/.zsh_plugins.zsh
```

**Impact:** 10-20ms improvement

### Reduce Plugin Count

**Audit plugins:**

```bash
antidote list
```

**Remove unused:**

```bash
vim ~/.config/zsh/.zsh_plugins.txt
# Remove unused plugins
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
```

### Optimize Completions

**Rebuild completion cache:**

```bash
rm -f ~/.cache/zsh/zcompcache/.zcompdump*
exec zsh
```

**Reduce completion sources:**

```bash
# In .zshrc
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' list-max-items 50
```

## Monitoring Performance

### Regular Profiling

```bash
# Add to monthly maintenance
ZSH_PROFILE_RC=1 zsh 2>&1 | tail -1
```

### Track Over Time

```bash
# Log startup time
echo "$(date): $(ZSH_PROFILE_RC=1 zsh 2>&1 | tail -1)" >> ~/.zsh_startup_log
```

### Set Alerts

```bash
# In .zshrc
if [[ -n "$ZSH_PROFILE_RC" ]]; then
  # Warn if startup > 300ms
  # (implement timing check)
fi
```

## Best Practices

1. **Profile before optimizing** - Measure first
1. **Defer non-essential plugins** - Faster startup
1. **Lazy-load version managers** - Biggest impact
1. **Keep .zshenv minimal** - Only essentials
1. **Cache expensive operations** - Avoid repeated work
1. **Compile Zsh files** - Small improvement
1. **Regular audits** - Remove unused plugins
1. **Monitor over time** - Catch regressions
1. **Target < 200ms** - Good user experience
1. **Test after changes** - Verify improvements

## Quick Reference

**Profile startup:**

```bash
ZSH_PROFILE_RC=1 zsh
```

**Defer plugin:**

```bash
# Add to .zsh_plugins.txt
plugin-name kind:defer

# Regenerate
antidote bundle <~/.config/zsh/.zsh_plugins.txt >~/.config/zsh/.zsh_plugins.zsh
```

**Lazy-load command:**

```bash
command() {
  unfunction command
  eval "$(command init -)"
  command "$@"
}
```

**Rebuild completions:**

```bash
rm -f ~/.cache/zsh/zcompcache/.zcompdump*
exec zsh
```

## Optimization Checklist

- [ ] Profile startup time
- [ ] Defer syntax highlighting
- [ ] Defer abbreviations
- [ ] Defer FZF integration
- [ ] Lazy-load pyenv
- [ ] Lazy-load rbenv
- [ ] Lazy-load nodenv
- [ ] Move expensive ops from .zshenv
- [ ] Cache brew prefix
- [ ] Compile .zshrc
- [ ] Remove unused plugins
- [ ] Rebuild completions
- [ ] Measure improvement
- [ ] Target < 200ms
