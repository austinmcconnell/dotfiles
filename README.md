# Dotfiles

<!-- toc -->

- [Install](#install)
- [Post-install](#post-install)
- [The `dotfiles` command](#the-dotfiles-command)
- [Documentation](#documentation)

<!-- tocstop -->

## Install

On a sparkling fresh installation of macOS:

```shell
    sudo softwareupdate -i -a
    xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS). Then, install
this repo with `curl` available:

```shell
    bash -c "`curl -fsSL https://raw.githubusercontent.com/austinmcconnell/dotfiles/master/remote-install.sh`"
```

This will clone (using `git`), or download (using `curl` or `wget`), this repo to `~/.dotfiles`. If
you prefer, you can manually clone into the desired location:

```shell
    git clone https://github.com/austinmcconnell/dotfiles.git ~/.dotfiles
```

Run setup script `install.sh`:

```shell
    cd ~/.dotfiles
    install.sh
```

## Post-install

- `dotfiles dock` (set [Dock items](./macos/dock.sh))
- `dotfiles macos` (set [macOS defaults](./macos/defaults.sh))

## The `dotfiles` command

```shell
    $ dotfiles help
    Usage: dotfiles <command>

    Commands:
       clean           |Clean up caches (brew, npm, gem, rvm)
       dock            |Apply macOS Dock settings
       edit            | Open dotfiles in IDE (code) and Git GUI (stree)
       help            |This help message
       macos           |Apply macOS system defaults
       test            |Run tests
       update          |Update packages and pkg managers (OS, brew, npm, gem)
```

## Documentation

- For repo-wide conventions shared across AI coding tools, see [AGENTS.md](./AGENTS.md)
- For how skills/steering/prompts are distributed to each tool, see
  [etc/ai/README.md](./etc/ai/README.md)
- For Kiro CLI's custom agent configuration, see [etc/kiro-cli/README.md](./etc/kiro-cli/README.md)
- For Claude Code's permissions, hooks, and personas, see
  [etc/claude-code/README.md](./etc/claude-code/README.md)
- For Cursor's CLI permissions and MCP config, see [etc/cursor/README.md](./etc/cursor/README.md)
- For local AI usage/cost tracking (SQLite store, Claude Code integration), see
  [etc/ai/usage/README.md](./etc/ai/usage/README.md)
