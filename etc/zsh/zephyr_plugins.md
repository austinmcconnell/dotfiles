# Zephyr Plugins Configuration

This document outlines the available zsh options and zstyles for each plugin in the Zephyr framework.

## Table of Contents

- [bootstrap](#bootstrap)
- [color](#color)
- [completion](#completion)
- [compstyle](#compstyle)
- [confd](#confd)
- [directory](#directory)
- [editor](#editor)
- [environment](#environment)
- [helper](#helper)
- [history](#history)
- [homebrew](#homebrew)
- [macos](#macos)
- [prompt](#prompt)
- [utility](#utility)
- [zfunctions](#zfunctions)

In zsh, options are boolean flags that are either enabled or disabled. Unlike zstyles which use
key-value pairs, zsh options are simply turned on or off using the setopt and unsetopt commands.

Here's how they work:

1. Enable an option: setopt option_name
2. Disable an option: unsetopt option_name or setopt NO_option_name

## bootstrap

The bootstrap module sets up the core Zephyr environment.

### zsh options

```zsh
setopt extended_glob interactive_comments
```

### zstyles

```zsh
# Check if bootstrap is loaded
zstyle -t ':zephyr:lib:bootstrap' loaded
```

## color

The color plugin enhances terminal color support.

### zsh options

No specific options set.

### zstyles

```zsh
# Skip loading the color plugin
zstyle ':zephyr:plugin:color' skip true

# Use cache for dircolors
zstyle ':zephyr:plugin:color' use-cache true  # Options: true, false

# Skip color aliases
zstyle ':zephyr:plugin:color:alias' skip true  # Options: true, false
```

## completion

The completion plugin configures Zsh's powerful completion system.

### zsh options

```zsh
setopt always_to_end        # Move cursor to the end of a completed word
setopt auto_list            # Automatically list choices on ambiguous completion
setopt auto_menu            # Show completion menu on a successive tab press
setopt auto_param_slash     # If completed parameter is a directory, add a trailing slash
setopt complete_in_word     # Complete from both ends of a word
setopt path_dirs            # Perform path search even on command names with slashes
setopt NO_flow_control      # Disable start/stop characters in shell editor
setopt NO_menu_complete     # Do not autoselect the first completion entry
```

### zstyles

```zsh
# Skip loading the completion plugin
zstyle ':zephyr:plugin:completion' skip true  # Options: true, false

# Use XDG base directories for completion cache
zstyle ':zephyr:plugin:completion' use-xdg-basedirs true  # Options: true, false

# Disable compfix (security checks for completion directories)
zstyle ':zephyr:plugin:completion' disable-compfix true  # Options: true, false

# Use completion caching
zstyle ':zephyr:plugin:completion' use-cache true  # Options: true, false

# Run completion initialization immediately instead of deferring to post_zshrc
zstyle ':zephyr:plugin:completion' immediate true  # Options: true, false

# Set completion style
zstyle ':zephyr:plugin:completion' compstyle zephyr  # Options: zephyr, none
```

## compstyle

The compstyle plugin provides a system for Zsh completion styles similar to the prompt system.

### zsh options

```zsh
# Set or unset case_glob based on case-sensitive configuration
setopt case_glob      # When case-sensitive is true
unsetopt case_glob    # When case-sensitive is false
```

### zstyles

```zsh
# Skip loading the compstyle plugin
zstyle ':zephyr:plugin:compstyle' skip true  # Options: true, false

# Enable case-sensitive completion
zstyle ':zephyr:plugin:compstyle:*' case-sensitive true  # Options: true, false

# Configure hosts to ignore in /etc/hosts for completion
zstyle ':zephyr:plugin:compstyle:*:hosts' etc-host-ignores '_etc_host_ignores'  # Array of hostnames to ignore
```

## confd

The confd plugin provides Fish-like configuration directory support.

### zsh options

No specific options set.

### zstyles

```zsh
# Skip loading the confd plugin
zstyle ':zephyr:plugin:confd' skip true  # Options: true, false

# Specify custom conf.d directory
zstyle ':zephyr:plugin:confd' directory '/path/to/conf.d'  # Path to conf.d directory

# Run confd initialization immediately instead of deferring to post_zshrc
zstyle ':zephyr:plugin:confd' immediate true  # Options: true, false
```

## directory

The directory plugin sets features related to Zsh directories and dirstack.

### zsh options

```zsh
setopt auto_pushd         # Make cd push the old directory onto the dirstack
setopt pushd_minus        # Exchanges meanings of +/- when navigating the dirstack
setopt pushd_silent       # Do not print the directory stack after pushd or popd
setopt pushd_to_home      # Push to home directory when no argument is given
setopt multios            # Write to multiple descriptors
setopt extended_glob      # Use extended globbing syntax (#,~,^)
setopt glob_dots          # Don't hide dotfiles from glob patterns
setopt NO_clobber         # Don't overwrite files with >. Use >| to bypass
setopt NO_rm_star_silent  # Ask for confirmation for `rm *' or `rm path/*'
```

### zstyles

```zsh
# Skip loading the directory plugin
zstyle ':zephyr:plugin:directory' skip true  # Options: true, false

# Skip directory aliases
zstyle ':zephyr:plugin:directory:alias' skip true  # Options: true, false
```

## editor

The editor plugin sets up Zsh line editor behavior.

### zsh options

```zsh
setopt NO_beep           # Do not beep on error in line editor
setopt NO_flow_control   # Allow the usage of ^Q/^S in the context of zsh
```

### zstyles

```zsh
# Skip loading the editor plugin
zstyle ':zephyr:plugin:editor' skip true  # Options: true, false

# Set custom wordchars (characters considered part of a word)
zstyle ':zephyr:plugin:editor' wordchars '*?_-.[]~&;!#$%^(){}<>'

# Set key bindings
zstyle ':zephyr:plugin:editor' key-bindings 'emacs'  # Options: 'emacs', 'vi'

# Enable dot expansion (.... expands to ../../..)
zstyle ':zephyr:plugin:editor' dot-expansion true  # Options: true, false

# Enable glob-alias expansion
zstyle ':zephyr:plugin:editor' glob-alias true  # Options: true, false

# Configure aliases that should not be expanded
zstyle ':zephyr:plugin:editor:glob-alias' noexpand 'alias1' 'alias2'  # Array of aliases

# Enable symmetric Ctrl-Z (toggles between foreground/background)
zstyle ':zephyr:plugin:editor' symmetric-ctrl-z true  # Options: true, false

# Configure magic-enter command
zstyle ':zephyr:plugin:editor:magic-enter' command 'ls .'  # Command to run on empty line + Enter
zstyle ':zephyr:plugin:editor:magic-enter' git-command 'git status -sb .'  # Command in git repos

# Configure cursor style in emacs mode
zstyle ':zephyr:plugin:editor:emacs:cursor' block true  # Options: true (block), false (line)
```

## environment

The environment plugin ensures common environment variables are set.

### zsh options

```zsh
setopt extended_glob         # Use more awesome globbing features
setopt NO_rm_star_silent     # Ask for confirmation for `rm *' or `rm path/*'
setopt combining_chars       # Combine 0-len chars with the base character
setopt interactive_comments  # Enable comments in interactive shell
setopt rc_quotes             # Allow 'Hitchhikers''s Guide' instead of 'Hitchhikers'\''s Guide'
setopt NO_mail_warning       # Don't print a warning message if a mail file has been accessed
setopt NO_beep               # Don't beep on error in line editor
setopt auto_resume           # Attempt to resume existing job before creating a new process
setopt long_list_jobs        # List jobs in the long format by default
setopt notify                # Report status of background jobs immediately
setopt NO_bg_nice            # Don't run all background jobs at a lower priority
setopt NO_check_jobs         # Don't report on jobs when shell exit
setopt NO_hup                # Don't kill jobs on shell exit
```

### zstyles

```zsh
# Skip loading the environment plugin
zstyle ':zephyr:plugin:environment' skip true  # Options: true, false

# Use XDG base directories
zstyle ':zephyr:plugin:environment' use-xdg-basedirs true  # Options: true, false

# Configure PATH prepending directories
zstyle ':zephyr:plugin:environment' prepath $HOME/bin $HOME/.local/bin  # Array of directories
```

## helper

The helper plugin provides common variables and functions used by Zephyr plugins.

### zsh options

No specific options set.

### zstyles

```zsh
# Check if helper is loaded
zstyle ':zephyr:plugin:helper' loaded  # Options: 'yes', 'no'
```

## history

The history plugin sets history options and defines history aliases.

### zsh options

```zsh
setopt bang_hist               # Treat the '!' character specially during expansion
setopt extended_history        # Write the history file in the ':start:elapsed;command' format
setopt hist_expire_dups_first  # Expire a duplicate event first when trimming history
setopt hist_find_no_dups       # Do not display a previously found event
setopt hist_ignore_all_dups    # Delete an old recorded event if a new event is a duplicate
setopt hist_ignore_dups        # Do not record an event that was just recorded again
setopt hist_ignore_space       # Do not record an event starting with a space
setopt hist_reduce_blanks      # Remove extra blanks from commands added to the history list
setopt hist_save_no_dups       # Do not write a duplicate event to the history file
setopt hist_verify             # Do not execute immediately upon history expansion
setopt inc_append_history      # Write to the history file immediately, not when the shell exits
setopt NO_hist_beep            # Don't beep when accessing non-existent history
setopt NO_share_history        # Don't share history between all sessions
```

### zstyles

```zsh
# Skip loading the history plugin
zstyle ':zephyr:plugin:history' skip true  # Options: true, false

# Set custom history file path
zstyle ':zephyr:plugin:history' histfile '$HOME/.zsh_history'  # Path to history file

# Use XDG base directories for history file
zstyle ':zephyr:plugin:history' use-xdg-basedirs true  # Options: true, false

# Set history size (number of commands to save in memory)
zstyle ':zephyr:plugin:history' histsize 20000  # Number of history entries

# Set save history size (number of commands to save to file)
zstyle ':zephyr:plugin:history' savehist 100000  # Number of history entries

# Skip history aliases
zstyle ':zephyr:plugin:history:alias' skip true  # Options: true, false
```

## homebrew

The homebrew plugin provides environment variables and functions for Homebrew users.

### zsh options

No specific options set.

### zstyles

```zsh
# Skip loading the homebrew plugin
zstyle ':zephyr:plugin:homebrew' skip true  # Options: true, false

# Use cache for brew shellenv
zstyle ':zephyr:plugin:homebrew' use-cache true  # Options: true, false

# Configure keg-only brews to add to fpath
zstyle ':zephyr:plugin:homebrew' keg-only-brews 'curl' 'ruby' 'sqlite'  # Array of brew names

# Skip homebrew aliases
zstyle ':zephyr:plugin:homebrew:alias' skip true  # Options: true, false
```

## macos

The macos plugin provides aliases and functions for macOS users.

### zsh options

No specific options set.

### zstyles

```zsh
# Skip loading the macos plugin
zstyle ':zephyr:plugin:macos' skip true  # Options: true, false
```

## prompt

The prompt plugin sets up the Zsh prompt.

### zsh options

```zsh
setopt prompt_subst  # Expand parameters in prompt variables
```

### zstyles

```zsh
# Skip loading the prompt plugin
zstyle ':zephyr:plugin:prompt' skip true  # Options: true, false

# Run prompt initialization immediately instead of deferring to post_zshrc
zstyle ':zephyr:plugin:prompt' immediate true  # Options: true, false

# Use cache for prompt initialization
zstyle ':zephyr:plugin:prompt' use-cache true  # Options: true, false

# Set prompt theme
zstyle ':zephyr:plugin:prompt' theme 'starship' 'zephyr'  # Options: any installed prompt theme
                                                          # Common: 'starship', 'p10k', built-in prompts
```

## utility

The utility plugin provides miscellaneous Zsh shell options and utilities.

### zsh options

No specific options set.

### zstyles

```zsh
# Skip loading the utility plugin
zstyle ':zephyr:plugin:utility' skip true  # Options: true, false
```

## zfunctions

The zfunctions plugin autoloads all function files from your `$ZDOTDIR/functions` directory.

### zsh options

No specific options set.

### zstyles

```zsh
# Skip loading the zfunctions plugin
zstyle ':zephyr:plugin:zfunctions' skip true  # Options: true, false

# Set custom functions directory
zstyle ':zephyr:plugin:zfunctions' directory '$HOME/.config/zsh/functions'  # Path to functions directory
```

## Global Zephyr Configuration

### zstyles

```zsh
# Configure which plugins to load
zstyle ':zephyr:load' plugins 'environment' 'homebrew' 'color' 'compstyle' 'completion' 'directory' 'editor' 'helper' 'history' 'prompt' 'utility' 'zfunctions' 'macos' 'confd'  # Array of plugin names

# Check if a plugin is loaded
zstyle ':zephyr:plugin:plugin-name' loaded  # Returns: 'yes' or 'no'
```
