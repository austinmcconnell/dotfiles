# Vim Configuration

A comprehensive, modern Vim configuration optimized for cross-platform development with Git-centric
workflows and auto-saving capabilities.

## Philosophy

- **Git-centric**: Integrated Git workflow with status indicators and branch information
- **Auto-saving**: Automatic file writing with undo history persistence
- **Comprehensive tooling**: Full-featured development environment with linting, completion, and
  navigation
- **Cross-platform**: Works consistently across macOS, Linux, and other Unix-like systems
- **Prose-friendly**: Opt-in prose linters and writing enhancements for essays and articles

## Directory Structure

```text
etc/vim/
├── .vimrc                 # Main configuration file
├── .ctags                 # Universal Ctags configuration
├── filetype.vim           # Custom filetype detection
├── after/
│   └── ftplugin/          # Language-specific settings (loaded after defaults)
├── plugin/                # Plugin-specific configurations
├── spell/                 # Custom spell check dictionaries
└── syntax/                # Custom syntax highlighting
```

## Architecture Overview

### Core Configuration (.vimrc)

The main configuration follows a structured approach with automatic plugin management via vim-plug.
Contains general settings, UI configuration, editing behavior, and navigation setup.

### Plugin System

Modular plugin configuration with each plugin having its own file in `plugin/` directory. Key
categories include:

- **Development**: Linting (ALE), completion, Git integration, file navigation
- **Editing**: Auto-pairs, commenting, undo management, text objects
- **UI**: Status line, colorschemes, file explorer
- **Workflow**: Session management, search tools, tag navigation
- **Writing**: Distraction-free mode (Goyo + Limelight), prose linters (opt-in)

### Language Support

Language-specific configurations in `after/ftplugin/` override defaults for:

- **Programming**: Python, Ruby, Shell (sh/zsh), JSON, Terraform
- **Markup**: Markdown (with prose variant), YAML
- **Git**: Commit messages, custom file types (slides, sshknownhosts)

### Key Conventions

- **Leader key**: Semicolon (`;`) for custom mappings
- **Modular approach**: Isolated plugin configurations prevent conflicts
- **External references**: Configuration files reference external dotfiles for consistency
- **Performance first**: Lazy loading, caching, and optimized settings

## Notable Features

### Prose Writing Enhancements

- **Punctuation-based undo**: Undo at sentence/clause boundaries for better prose editing
- **Quick spell correction**: `<C-l>` auto-corrects previous misspelled word
- **Opt-in prose linters**: Three ways to enable proselint/writegood:
  - Modeline: `<!-- vim: set ft=markdown.prose: -->`
  - Commands: `:ProseOn` / `:ProseOff`
  - Auto-enable: Files in `writing/`, `blog/`, `essays/`, `articles/`, `drafts/`, `posts/`
    directories

### Development Workflow

- **Auto-save with undo history**: No swap files, persistent undo across sessions
- **Comprehensive linting**: ALE with 9+ languages (Python, Go, Ruby, Shell, Terraform, etc.)
- **Git integration**: GitGutter diff indicators, branch info in status line
- **Tag-based navigation**: Auto-generated ctags with gutentags

## Finding Specific Information

- **Key mappings**: Check individual plugin files in `plugin/`
- **Language settings**: Look in `after/ftplugin/{language}.vim`
- **Linting configuration**: See `plugin/ale.vim` for comprehensive language support
- **Prose writing**: Use `:ProseOn` to enable proselint/writegood, or add modeline
  `<!-- vim: set ft=markdown.prose: -->`
- **Custom syntax**: Check `syntax/` and `filetype.vim` for special file types
- **Spell checking**: Custom dictionary in `spell/en.utf-8.add`, `<C-l>` for quick correction

This configuration provides a complete development environment while maintaining Vim's philosophy of
efficiency and keyboard-driven workflows.
