# Tool Configurations

This document provides detailed information about the purpose and configuration options for each tool
in the `etc/` directory of the dotfiles repository.

## Table of Contents

<!-- toc -->

- [ag (The Silver Searcher)](#ag-the-silver-searcher)
- [Amazon Q](#amazon-q)
- [bat](#bat)
- [direnv](#direnv)
- [fd](#fd)
- [Git](#git)
- [HTTPie](#httpie)
- [iTerm2](#iterm2)
- [kind (Kubernetes in Docker)](#kind-kubernetes-in-docker)
- [Miscellaneous](#miscellaneous)
- [Node.js](#nodejs)
- [Nuphy](#nuphy)
- [Python](#python)
- [Ruby](#ruby)
- [Spaceship](#spaceship)
- [SSH](#ssh)
- [Starship](#starship)
- [Sublime Text](#sublime-text)
- [Terminfo](#terminfo)
- [Vim](#vim)
- [YAML](#yaml)
- [Zsh](#zsh)

<!-- tocstop -->

## ag (The Silver Searcher)

The Silver Searcher is a code-searching tool similar to `ack` but faster. It helps you search through
codebases quickly with support for regular expressions.

Configuration options include:

- **Ignore patterns**: Configure which files and directories to ignore during searches
- **Search depth**: Control how deep in the directory structure to search
- **Output formatting**: Customize how search results are displayed

## Amazon Q

Amazon Q is an AI-powered assistant that helps with coding, answering questions, and providing
recommendations. It integrates with your development workflow to enhance productivity.

Configuration options include:

- **Global context**: Settings in `global_context.json` that apply across all profiles
- **Profile-specific contexts**: Custom configurations for different development scenarios
- **Application settings**: General settings for the Amazon Q application
- **IDE integrations**: Configuration for editor integrations

For more detailed information, see the [Amazon Q Integration](AmazonQIntegration.md) guide.

## bat

`bat` is a `cat` clone with syntax highlighting, Git integration, and other features that enhance
viewing file contents in the terminal.

Configuration options include:

- **Theme selection**: Choose from various syntax highlighting themes
- **Style customization**: Configure how line numbers, grid, and headers are displayed
- **Pager settings**: Control how content is paginated
- **Language detection**: Configure how file types are detected and highlighted

## direnv

direnv is an environment switcher that automatically loads and unloads environment variables depending
on the current directory, making project-specific environments easier to manage.

Configuration options include:

- **Allow/deny rules**: Control which directories can modify your environment
- **Environment variables**: Define project-specific environment variables
- **Path extensions**: Add project-specific directories to your PATH
- **Hook configuration**: Customize when and how direnv activates

## fd

`fd` is a simple, fast, and user-friendly alternative to the `find` command, optimized for
developer workflows.

Configuration options include:

- **Ignore patterns**: Specify files and directories to exclude from searches
- **Search depth**: Control how deep in the directory structure to search
- **Color settings**: Customize the colorized output
- **Match options**: Configure case sensitivity and regex patterns

## Git

Git is a distributed version control system. The configuration in this directory manages Git behavior,
aliases, and templates.

Configuration options include:

- **User information**: Configure name, email, and signing key
- **Aliases**: Define shortcuts for common Git commands
- **Diff and merge tools**: Configure tools for resolving conflicts
- **Hooks**: Set up automated scripts that run at specific points in the Git workflow
- **Ignore patterns**: Global patterns for files to exclude from Git repositories
- **Branch management**: Default branch names and remote tracking behavior
- **Commit message templates**: Standardized formats for commit messages

## HTTPie

HTTPie is a command-line HTTP client that makes CLI interaction with web services as
user-friendly as possible.

Configuration options include:

- **Default headers**: Configure headers sent with every request
- **Authentication**: Set up default authentication methods
- **Output formatting**: Control how responses are displayed
- **Session management**: Configure persistent sessions for specific APIs

## iTerm2

iTerm2 is an enhanced terminal emulator for macOS with features beyond the default Terminal app.

Configuration options include:

- **Color schemes**: Define and customize terminal color palettes
- **Profiles**: Configure different terminal profiles for various use cases
- **Key mappings**: Customize keyboard shortcuts
- **Window arrangements**: Save and restore window layouts
- **Shell integration**: Configure advanced shell features

## kind (Kubernetes in Docker)

kind lets you run Kubernetes clusters using Docker containers as nodes, making it easy to create and
test Kubernetes configurations locally.

Configuration options include:

- **Cluster configurations**: Define node counts and roles
- **Networking settings**: Configure how the cluster networks are set up
- **Volume mounts**: Map local directories into the cluster
- **API server settings**: Customize the Kubernetes API server
- **Registry configuration**: Set up local container registries

## Miscellaneous

This directory contains configurations for various small utilities that don't warrant their own
dedicated directories.

Configuration options vary by tool, typically including basic preferences and defaults.

## Node.js

Configurations for Node.js development environment, including npm and yarn settings.

Configuration options include:

- **npm configuration**: Global npm settings and defaults
- **Package management**: Configure npm and yarn behavior
- **Version management**: nvm settings for managing Node.js versions
- **Development tools**: Configuration for linters, formatters, and other tools

## Nuphy

Configuration for Nuphy keyboards, including key mappings and firmware settings.

Configuration options include:

- **Key mappings**: Customize keyboard layout and function keys
- **Macros**: Define custom key sequences
- **Lighting effects**: Configure RGB lighting patterns and colors
- **Firmware settings**: Options for keyboard firmware behavior

## Python

Python development environment configuration, including package management and virtual
environment settings.

Configuration options include:

- **pyenv configuration**: Manage Python versions
- **pip settings**: Configure package installation behavior
- **Virtual environments**: Set up and manage isolated Python environments
- **Linting and formatting**: Configure tools like flake8, black, and isort
- **IPython/Jupyter**: Customize interactive Python environments

## Ruby

Ruby development environment configuration, including gem management and version settings.

Configuration options include:

- **rbenv configuration**: Manage Ruby versions
- **gem settings**: Configure gem installation behavior
- **Bundler options**: Control dependency management
- **Development tools**: Configure linters and formatters

## Spaceship

Spaceship is a prompt for Zsh that displays information about the current directory, Git status,
and more in a clean, minimal way.

Configuration options include:

- **Prompt sections**: Enable or disable different information sections
- **Symbol customization**: Change the symbols used in the prompt
- **Color schemes**: Customize the colors of different prompt elements
- **Order configuration**: Rearrange the order of information display

## SSH

Secure Shell (SSH) configuration for remote server access and authentication.

Configuration options include:

- **Host definitions**: Configure connection settings for different servers
- **Key management**: Set up and organize SSH keys
- **Authentication methods**: Configure password, key-based, and other authentication methods
- **Connection options**: Set timeouts, compression, and other connection parameters
- **ProxyJump configurations**: Set up jump hosts for accessing servers behind firewalls

## Starship

Starship is a minimal, blazing-fast, and infinitely customizable prompt for any shell.

Configuration options include:

- **Prompt modules**: Enable or disable different information sections
- **Symbol customization**: Change the symbols used in the prompt
- **Color schemes**: Customize the colors of different prompt elements
- **Format strings**: Control the exact format of each prompt section

## Sublime Text

Sublime Text is a sophisticated text editor for code, markup, and prose with a slick user interface
and exceptional features.

Configuration options include:

- **User preferences**: General editor settings and behavior
- **Key bindings**: Customize keyboard shortcuts
- **Package settings**: Configure installed packages and plugins
- **Syntax-specific settings**: Language-specific editor behaviors
- **Color schemes**: Visual themes for the editor
- **Build systems**: Configure how code is compiled or run

## Terminfo

Terminfo database entries that define terminal capabilities, ensuring proper display of colors and
special characters.

Configuration options include:

- **Terminal definitions**: Configure how different terminals interpret control sequences
- **Color support**: Define color capabilities for various terminals
- **Special keys**: Map keyboard input to terminal control sequences
- **Screen capabilities**: Configure terminal screen management features

## Vim

Vim is a highly configurable text editor built to enable efficient text editing. This directory
contains Vim configuration files and plugins.

Configuration options include:

- **General settings**: Basic editor behavior like line numbers and indentation
- **Key mappings**: Custom keyboard shortcuts
- **Plugin management**: Configure vim-plug and installed plugins
- **Color schemes**: Visual themes for the editor
- **Filetype-specific settings**: Language-specific editor behaviors
- **Status line configuration**: Customize the information displayed in the status line

## YAML

Configuration for YAML file handling, including linting and formatting tools.

Configuration options include:

- **Linting rules**: Configure validation for YAML files
- **Formatting options**: Set indentation and line length preferences
- **Schema validation**: Configure validation against specific YAML schemas
- **Aliases handling**: Control how YAML aliases are processed

## Zsh

Zsh is an extended shell with improved features over bash. This directory contains Zsh configuration
files, plugins, and themes.

Configuration options include:

- **Plugin management**: Configure antidote and installed plugins
- **Aliases**: Define command shortcuts
- **Functions**: Create custom shell functions
- **Completion settings**: Configure tab completion behavior
- **History options**: Control command history behavior and size
- **Key bindings**: Customize keyboard shortcuts
- **Theme configuration**: Set up and customize shell appearance
- **Directory navigation**: Configure auto-cd and directory stack features
