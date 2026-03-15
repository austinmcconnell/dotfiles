# Utility Functions Reference

## Homebrew Cache Management

### `init_brew_cache()`

**Purpose:** Initialize or load cached Homebrew data

**Behavior:**

- Checks if cache exists and is fresh (< 5 minutes old)
- Loads from cache if fresh
- Refreshes cache if stale or missing
- Caches: installed formulae, casks, outdated packages, taps

**Usage:**

```bash
init_brew_cache
```

**Cache location:** `~/.cache/dotfiles/brew_cache`

**Cache TTL:** 300 seconds (5 minutes)

**Why use it:** Significantly speeds up multiple install scripts by avoiding repeated `brew list`
calls.

---

### `refresh_brew_cache()`

**Purpose:** Force cache refresh

**Behavior:**

- Deletes existing cache
- Calls `init_brew_cache()` to rebuild

**Usage:**

```bash
refresh_brew_cache
```

**When to use:** After installing or updating packages to ensure cache is current.

---

## Package Installation

### `install_if_needed <package> [type] [install_type]`

**Purpose:** Install or update Homebrew package if needed

**Parameters:**

- `package` (required) - Package name
- `type` (optional) - "formula" (default) or "cask"
- `install_type` (optional) - "both" (default), "personal", or "work"

**Behavior:**

1. Checks if package is installed
1. If not installed: installs package
1. If installed but outdated: updates package
1. If installed and up-to-date: skips with success message
1. Respects work/personal computer settings from `~/.extra/.env`

**Examples:**

```bash
# Install formula (default)
install_if_needed "git"

# Install cask
install_if_needed "visual-studio-code" "cask"

# Personal computer only
install_if_needed "spotify" "cask" "personal"

# Work computer only
install_if_needed "slack" "cask" "work"

# Both (explicit)
install_if_needed "git" "formula" "both"
```

**Output:**

- Installing: "Installing package (type)..."
- Updating: "Updating package (type)..."
- Up-to-date: "✓ package is already installed and up to date"
- Skipped: "⚠️ Skipping package (type) installation on work/personal computer"

**Requirements:**

- `~/.extra/.env` must exist with `IS_WORK_COMPUTER` variable
- Brew cache must be initialized

---

### `tap_if_needed <tap>`

**Purpose:** Add Homebrew tap if not already added

**Parameters:**

- `tap` (required) - Tap name (e.g., "homebrew/cask-fonts")

**Behavior:**

1. Checks if tap exists
1. If not: adds tap
1. If exists: skips with message

**Usage:**

```bash
tap_if_needed "homebrew/cask-fonts"
install_if_needed "font-fira-code" "cask"
```

**Output:**

- Adding: "Tapping tap..."
- Exists: "Tap tap already exists"

---

## Package Status Checks

### `is_package_installed <package> [type]`

**Purpose:** Check if package is installed

**Parameters:**

- `package` (required) - Package name
- `type` (optional) - "formula" (default) or "cask"

**Returns:**

- 0 if installed
- 1 if not installed

**Usage:**

```bash
if is_package_installed "git"; then
    echo "Git is installed"
fi

if is_package_installed "visual-studio-code" "cask"; then
    echo "VS Code is installed"
fi
```

---

### `is_package_outdated <package> [type]`

**Purpose:** Check if package is outdated

**Parameters:**

- `package` (required) - Package name
- `type` (optional) - "formula" (default) or "cask"

**Returns:**

- 0 if outdated
- 1 if up-to-date

**Usage:**

```bash
if is_package_outdated "git"; then
    echo "Git needs updating"
fi
```

---

## Output Formatting

### `print_header <message>`

**Purpose:** Print formatted header with asterisks

**Parameters:**

- `message` (required) - Header text

**Output:**

```text
**************************************************
Message
**************************************************
```

**Usage:**

```bash
print_header "Installing Development Tools"
```

---

## Cache Variables

After calling `init_brew_cache()`, these variables are available:

**`BREW_INSTALLED_FORMULAE`**

- Newline-separated list of installed formulae
- Example: "git\\nvim\\ntmux"

**`BREW_INSTALLED_CASKS`**

- Newline-separated list of installed casks
- Example: "visual-studio-code\\niterm2"

**`BREW_OUTDATED_FORMULAE`**

- Newline-separated list of outdated formulae

**`BREW_OUTDATED_CASKS`**

- Newline-separated list of outdated casks

**`BREW_TAPS`**

- Newline-separated list of taps
- Example: "homebrew/core\\nhomebrew/cask"

**Usage:**

```bash
init_brew_cache
echo "$BREW_INSTALLED_FORMULAE" | grep "^git$"
```

---

## Function Dependencies

**`install_if_needed` requires:**

- `init_brew_cache()` called first
- `~/.extra/.env` with `IS_WORK_COMPUTER` variable
- `is_package_installed()`
- `is_package_outdated()`
- `refresh_brew_cache()`

**`tap_if_needed` requires:**

- `init_brew_cache()` called first
- `refresh_brew_cache()`

**`is_package_installed` requires:**

- `init_brew_cache()` called first
- `BREW_INSTALLED_FORMULAE` or `BREW_INSTALLED_CASKS` variables

**`is_package_outdated` requires:**

- `init_brew_cache()` called first
- `BREW_OUTDATED_FORMULAE` or `BREW_OUTDATED_CASKS` variables

---

## Error Handling

**Missing `~/.extra/.env`:**

```text
Error: /Users/user/.extra/.env not found. Please run install.sh first.
```

**Failed cache initialization:**

```text
Warning: Failed to initialize brew cache
```

**Cache initialization returns 1** if both `BREW_INSTALLED_FORMULAE` and `BREW_INSTALLED_CASKS` are
empty.

---

## Performance Considerations

**Cache benefits:**

- Single `brew list` call instead of one per package
- 5-minute TTL balances freshness and performance
- Shared across all install scripts in same run

**When to refresh:**

- After installing packages
- After updating packages
- After adding taps

**When NOT to refresh:**

- Between package checks
- During read-only operations

---

## Best Practices

1. **Always call `init_brew_cache()` first** - Required for package functions
1. **Call `refresh_brew_cache()` after modifications** - Keeps cache current
1. **Use `install_if_needed` over direct `brew install`** - Handles idempotency
1. **Check package status before custom logic** - Use `is_package_installed`
1. **Group related packages** - Install in batches for efficiency
1. **Print clear messages** - Use `print_header` for sections
1. **Handle work/personal split** - Use install_type parameter
1. **Don't assume cache is fresh** - Always call `init_brew_cache()`
