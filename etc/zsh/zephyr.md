# Zephyr Framework

Zephyr is a lightweight, modular Zsh framework designed to provide essential functionality while
maintaining speed and simplicity.

## Core Architecture

Zephyr's architecture is built around independent plugins that can be loaded individually or as a
complete set. The framework is designed to be:

- **Modular**: Each component is self-contained
- **Fast**: Optimized for quick shell startup
- **Simple**: Clean, well-documented code
- **Extensible**: Easy to add custom functionality

## Directory Structure

```shell
zephyr/
├── bin/                  # Executable scripts
├── lib/                  # Core library files
│   └── bootstrap.zsh     # Framework initialization
├── plugins/              # Individual feature modules
│   ├── color/
│   ├── completion/
│   ├── directory/
│   └── ...
├── runcoms/              # Example configuration files
├── tests/                # Test suite
├── zephyr.plugin.zsh     # Plugin compatibility file
└── zephyr.zsh            # Main entry point
```

## Initialization Process

When Zephyr is sourced, it follows this initialization process:

1. **Bootstrap**: Sets up essential environment variables and functions
2. **Plugin Loading**: Loads the specified plugins in order
3. **Post-Initialization**: Executes any registered post-initialization hooks

The bootstrap phase is particularly important as it:

- Sets critical Zsh options (`extended_glob`, `interactive_comments`)
- Establishes standard XDG directory locations
- Sets up the post-initialization hook system
- Loads helper functions

## Plugin System

Zephyr's plugin system is the core of its modularity. Each plugin:

- Is contained in its own directory
- Has a main file named `plugin-name.plugin.zsh`
- May include additional directories for functions and completions
- Can be loaded independently of other plugins

### Available Plugins

Zephyr includes the following core plugins:

| Plugin | Description |
|--------|-------------|
| `color` | Terminal color support and configuration |
| `completion` | Zsh's powerful completion system |
| `compstyle` | Completion styling and configuration |
| `confd` | Fish-like configuration directory support |
| `directory` | Directory navigation and management |
| `editor` | Keybindings and editor integration |
| `environment` | Environment variable management |
| `helper` | Internal helper functions |
| `history` | Command history configuration |
| `homebrew` | Homebrew integration for macOS |
| `macos` | macOS-specific functionality |
| `prompt` | Prompt configuration (with optional Starship support) |
| `utility` | Common shell utilities and functions |
| `zfunctions` | Fish-like function autoloading |

### Plugin Structure

Each plugin follows a consistent structure:

```shell
plugins/plugin-name/
├── plugin-name.plugin.zsh    # Main plugin file
├── functions/                # Optional functions directory
│   └── function-name         # Individual function files
└── completions/              # Optional completions directory
    └── _command              # Completion functions
```

## Configuration System

Zephyr uses Zsh's built-in `zstyle` system for configuration. This provides a hierarchical,
context-based way to configure various aspects of the framework.

### Key Configuration Points

```zsh
# Specify which plugins to load
zstyle ':zephyr:load' plugins 'directory' 'history' 'editor'

# Plugin-specific configuration
zstyle ':zephyr:plugin:history' histsize 10000
zstyle ':zephyr:plugin:editor' key-bindings 'emacs'
```

### Post-Initialization Hooks

Zephyr provides a post-initialization hook system that allows code to run after Zsh is fully initialized:

```zsh
# Add functions to the post_zshrc hook
post_zshrc_hook+=('my_custom_function')
```

This is particularly useful for operations that need to happen after all plugins are loaded.

## Custom Plugins

Zephyr supports custom plugins through the `ZSH_CUSTOM` directory:

```zsh
${ZSH_CUSTOM:-$__zsh_config_dir}/plugins/custom-plugin/custom-plugin.plugin.zsh
```

Custom plugins take precedence over built-in plugins with the same name, allowing for easy
overriding of default behavior.

## Integration with Plugin Managers

While Zephyr can be used standalone, it's designed to work well with plugin managers like Antidote.
When used with Antidote, individual Zephyr plugins can be loaded as needed:

```conf
# .zsh_plugins.txt
mattmc3/zephyr path:plugins/directory
mattmc3/zephyr path:plugins/history
mattmc3/zephyr path:plugins/editor
```

This allows for fine-grained control over which parts of Zephyr are loaded.

## Performance Considerations

Zephyr is designed with performance in mind:

- Plugins only load what's necessary
- Functions are autoloaded rather than pre-loaded
- The framework avoids expensive operations during startup
- Plugins check requirements before loading unnecessary code

## Best Practices

1. **Load Only What You Need**: Only enable the plugins you actually use
2. **Order Matters**: Some plugins depend on others, so order can be important
3. **Use Custom Plugins**: Override built-in plugins with custom versions when needed
4. **Leverage Post-Initialization**: Use hooks for operations that can be deferred
5. **Combine with Antidote**: Use Antidote to manage Zephyr and other plugins together
