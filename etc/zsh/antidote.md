# Antidote Plugin Manager

Antidote is a high-performance Zsh plugin manager that handles downloading, updating, and loading
Zsh plugins. It's a feature-complete implementation of the legacy Antibody plugin manager, with
improvements for speed and usability.

## Core Architecture

Antidote's architecture is built around several key components:

- **Bundle Management**: Handles plugin specification and installation
- **Static Generation**: Creates optimized load files for performance
- **Plugin Loading**: Sources plugins with appropriate configuration
- **Command Interface**: Provides a simple CLI for managing plugins

## Directory Structure

```shell
antidote/
├── antidote              # Main executable script
├── antidote.zsh          # Main source file for Zsh
├── functions/            # Autoloadable functions
│   ├── antidote-*        # Public commands
│   └── __antidote_*      # Internal helper functions
├── man/                  # Manual pages
├── tests/                # Test suite
└── tools/                # Utility scripts
```

## Initialization Process

When Antidote is sourced, it follows this initialization process:

1. **Version Check**: Ensures Zsh version is compatible (5.4.2+)
2. **Setup**: Loads functions and sets up environment
3. **Configuration**: Applies user configuration via zstyle

The setup phase is particularly important as it:

- Adds function directories to `fpath`
- Autoloads all functions
- Sets up man pages
- Configures command-line options

## Bundle Management

Antidote uses a simple text file (typically `.zsh_plugins.txt`) to define plugins. Each line
specifies a plugin with optional parameters:

### Bundle Format

```conf
# Basic format: user/repo
zsh-users/zsh-autosuggestions

# With path specifier
ohmyzsh/ohmyzsh path:plugins/git

# With branch/tag/commit
zsh-users/zsh-syntax-highlighting branch:master

# With loading kind
zsh-users/zsh-history-substring-search kind:defer

# Full URL format
https://github.com/romkatv/powerlevel10k

# Local plugin
/path/to/local/plugin
```

### Bundle Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `path:` | Subdirectory to load | `path:plugins/git` |
| `branch:` | Git reference to use | `branch:develop` |
| `kind:` | Loading behavior | `kind:defer` |
| `pick:` | Specific files to source | `pick:theme.zsh` |

### Loading Kinds

Antidote supports several loading kinds:

- **Default**: Clone and source the plugin
- **`defer`**: Load the plugin after Zsh initialization
- **`clone`**: Clone without sourcing
- **`fpath`**: Add to FPATH without sourcing
- **`path`**: Add to PATH without sourcing

## Command Interface

Antidote provides a comprehensive command interface:

```zsh
antidote [command] [options]
```

### Core Commands

| Command | Description |
|---------|-------------|
| `bundle` | Generate static load script from bundle file |
| `help` | Show help information |
| `home` | Print or change the antidote home directory |
| `init` | Initialize antidote |
| `install` | Install a plugin |
| `list` | List installed plugins |
| `load` | Load plugins from a bundle file |
| `path` | Print the path to a plugin |
| `purge` | Remove a plugin |
| `update` | Update plugins |

## Performance Optimization

Antidote offers several performance optimizations:

### Static Loading

The most significant performance feature is static loading, which pre-generates a Zsh script that
can be sourced directly:

```zsh
# Generate static file
antidote bundle <${ZDOTDIR:-$HOME}/.zsh_plugins.txt >${ZDOTDIR:-$HOME}/.zsh_plugins.zsh

# Source static file
source ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh
```

This approach is much faster than dynamic loading because:

- It eliminates the need to parse the bundle file on each startup
- It pre-resolves plugin paths and dependencies
- It can be zcompiled for even faster loading

### Deferred Loading

Antidote supports deferred loading for plugins that don't need to be loaded immediately:

```conf
# .zsh_plugins.txt
zsh-users/zsh-syntax-highlighting kind:defer
zsh-users/zsh-autosuggestions kind:defer
```

Deferred plugins are loaded after Zsh initialization, which can significantly improve startup time.

### Parallel Cloning

When installing multiple plugins, Antidote clones them in parallel:

```zsh
antidote bundle <${ZDOTDIR:-$HOME}/.zsh_plugins.txt
```

This makes initial setup much faster than sequential cloning.

### Zcompilation

Antidote can automatically compile scripts for faster loading:

```zsh
zstyle ':antidote:static' zcompile on
```

## Configuration System

Antidote uses Zsh's built-in `zstyle` system for configuration:

```zsh
# Set bundle file location
zstyle ':antidote:bundle' file ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# Set static file location
zstyle ':antidote:static' file ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh

# Enable zcompilation
zstyle ':antidote:static' zcompile on

# Use friendly directory names
zstyle ':antidote:bundle' use-friendly-names on

# Set compatibility mode
zstyle ':antidote:compatibility-mode' 'antibody' 'on'
```

## Integration with Zsh Frameworks

Antidote works well with Zsh frameworks like Zephyr. It can be used to load framework components selectively:

```conf
# .zsh_plugins.txt
mattmc3/zephyr path:plugins/directory
mattmc3/zephyr path:plugins/history
```

This allows for fine-grained control over which parts of a framework are loaded.

## Best Practices

1. **Use Static Loading**: Generate a static file for maximum performance
2. **Defer Non-Essential Plugins**: Use `kind:defer` for plugins that don't need immediate loading
3. **Organize Your Bundle File**: Group plugins by category and use comments
4. **Consider Dependencies**: Order plugins correctly if they depend on each other
5. **Use Zcompilation**: Enable zcompilation for frequently used scripts
6. **Update Regularly**: Keep plugins updated with `antidote update`
7. **Be Selective**: Only load plugins you actually use
