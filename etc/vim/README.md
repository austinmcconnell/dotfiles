# Vim Configuration

A comprehensive, modern Vim configuration optimized for cross-platform development with
Git-centric workflows and auto-saving capabilities.

## Philosophy

- **Git-centric**: Integrated Git workflow with status indicators and branch information
- **Auto-saving**: Automatic file writing with undo history persistence
- **Comprehensive tooling**: Full-featured development environment with linting, completion,
  and navigation
- **Cross-platform**: Works consistently across macOS, Linux, and other Unix-like systems

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

The main configuration follows a structured approach with automatic plugin management via
vim-plug. Contains general settings, UI configuration, editing behavior, and navigation setup.

### Plugin System

Modular plugin configuration with each plugin having its own file in `plugin/` directory.
Key categories include:

- **Development**: Linting (ALE), completion, Git integration, file navigation
- **Editing**: Auto-pairs, commenting, undo management, text objects
- **UI**: Status line, colorschemes, file explorer
- **Workflow**: Session management, search tools, tag navigation

### Language Support

Language-specific configurations in `after/ftplugin/` override defaults for:

- Python, JavaScript, Go, Ruby, Shell scripts
- Markdown, YAML, JSON, Terraform
- Git commit messages and custom file types

### Key Conventions

- **Leader key**: Semicolon (`;`) for custom mappings
- **Modular approach**: Isolated plugin configurations prevent conflicts
- **External references**: Configuration files reference external dotfiles for consistency
- **Performance first**: Lazy loading, caching, and optimized settings

## Finding Specific Information

- **Key mappings**: Check individual plugin files in `plugin/`
- **Language settings**: Look in `after/ftplugin/{language}.vim`
- **Linting configuration**: See `plugin/ale.vim` for comprehensive language support
- **Custom syntax**: Check `syntax/` and `filetype.vim` for special file types
- **Spell checking**: Custom dictionary in `spell/en.utf-8.add`

This configuration provides a complete development environment while maintaining Vim's
philosophy of efficiency and keyboard-driven workflows.
