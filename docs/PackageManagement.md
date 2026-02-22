# Package Management

This guide explains how package management works in the dotfiles repository, covering both macOS and
Debian-based Linux systems.

## Overview

The dotfiles repository uses different package managers depending on the operating system:

- **macOS**: Homebrew for system packages and applications
- **Debian-based Linux**: APT for system packages and Snap for applications

## macOS Package Management

### Homebrew

Homebrew is the primary package manager for macOS. The installation and configuration are handled by
`install/brew.sh`.

#### Installation

Homebrew is automatically installed if not already present:

```bash
if ! is-executable brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
```

#### Core Packages

A set of core command-line utilities is installed regardless of whether it's a work or personal
computer:

```bash
brew install coreutils
brew install moreutils
brew install findutils
# ... and more
```

#### Conditional Packages

Some packages are only installed based on whether it's a work or personal computer:

```bash
if ! is-work; then
    brew install youtube-dl
    # ... other personal packages
fi
```

### Mac App Store

For macOS applications available through the App Store, the `mas` command-line tool is used:

```bash
if ! is-work; then
    mas install 409183694 # Keynote
    mas install 409201541 # Pages
    # ... other Mac App Store applications
fi
```

## Debian Package Management

### APT

For Debian-based systems, APT is used to install system packages. The installation is handled by
`install/apt.sh`.

```bash
if is-debian; then
    sudo apt update
    sudo apt install -y build-essential
    sudo apt install -y curl
    # ... other packages
fi
```

### Snap

Snap packages are used for some applications on Debian systems:

```bash
if is-debian; then
    sudo snap install spotify
    # ... other snap packages
fi
```

## Language-Specific Package Managers

### Python (pyenv)

Python versions are managed using pyenv, which is installed and configured in `install/python.sh`:

```bash
if ! is-executable pyenv; then
    curl https://pyenv.run | bash
fi
```

### Node.js (nvm)

Node.js versions are managed using nvm, which is installed and configured in `install/node.sh`:

```bash
if ! is-executable nvm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi
```

### Ruby (rbenv)

Ruby versions are managed using rbenv, which is installed and configured in `install/ruby.sh`:

```bash
if ! is-executable rbenv; then
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
fi
```

## Updating Packages

To update all packages across all package managers, use the `dotfiles update` command, which:

1. Updates macOS App Store applications (if not a work computer)
2. Updates Homebrew packages (on macOS)
3. Updates APT packages (on Debian)
4. Updates Snap packages (on Debian)
5. Updates antidote (Zsh plugin manager)
6. Updates pyenv
7. Updates vim-plug plugins
8. Updates repositories in `~/.repositories`

## Cleaning Up

To clean up caches and remove unused packages, use the `dotfiles clean` command, which:

1. Runs `brew cleanup` and `brew autoremove` (on macOS)
2. Runs `apt clean` and `apt autoremove` (on Debian)
3. Runs `vim -i NONE -c "PlugClean" -c "qa"` to clean up Vim plugins

## Adding New Packages

To add new packages to your dotfiles:

1. For system-wide packages, add them to the appropriate section in `install/brew.sh` or
   `install/apt.sh`
2. For Python packages, add them to `install/python.sh`
3. For Node.js packages, add them to `install/node.sh`
4. For Vim plugins, add them to your `.vimrc` file

Remember to test your changes by running the appropriate installation script or using the
`dotfiles update` command.
