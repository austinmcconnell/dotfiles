# macOS

Scripts that configure a macOS machine beyond what the package installers do: App Store apps, system
defaults, and Dock layout. They are meant to be run through the `dotfiles mac` subcommands (see
`dotfiles help`), not directly. Each file is sourced, not executed, so it relies on the `dotfiles`
environment (for example `is-executable`).

| File               | Run with                     | What it does                                                |
| :----------------- | :--------------------------- | :---------------------------------------------------------- |
| `apps.sh`          | `dotfiles mac apps`          | Installs Mac App Store apps with `mas`; needs Homebrew      |
| `defaults.sh`      | `dotfiles mac defaults`      | Applies about 40 `defaults write` settings; asks for `sudo` |
| `dock-personal.sh` | `dotfiles mac dock personal` | Rebuilds the Dock for a personal machine with `dockutil`    |
| `dock-work.sh`     | `dotfiles mac dock work`     | Rebuilds the Dock for a work machine with `dockutil`        |

## Behavior to know

- `install.sh` also sources `apps.sh` during a full install.
- `apps.sh` returns early, installing nothing, when `brew` is missing or `IS_WORK_COMPUTER` is `1`.
- `dotfiles mac defaults` sources every `macos/defaults*.sh` file, so a machine-specific
  `defaults-<name>.sh` added here would also run.
- The computer-name settings in `defaults.sh` are commented out; set `COMPUTER_NAME` and uncomment
  them to use them.
- Some defaults only take effect after a logout or restart.
