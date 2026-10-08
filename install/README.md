# Install Scripts

Modular installation framework for macOS and Debian dotfiles. Each script in this directory handles
one tool or environment, checking for existing installations, installing if needed, and symlinking
configuration files from `etc/` into XDG-compliant home directory locations. All scripts are meant
to be idempotent—safe to run repeatedly. Platform checks use the helpers in `bin/` (`is-macos`,
`is-debian`, `is-executable`). Only `brew.sh`, `ghostty.sh`, `extra.sh`, `sops.sh`, and `typora.sh`
source the shared helpers in `install/utils.sh`.

## Installation Scripts

| Script            | Installs / Configures                                      | Notable Details                                            |
| ----------------- | ---------------------------------------------------------- | ---------------------------------------------------------- |
| git.sh            | Git, config files, hooks, maintenance                      | Sets up global git maintenance tasks                       |
| zsh.sh            | Zsh shell, antidote plugin manager, starship, iTerm2       | Installs completions, iterm2_shell_integration             |
| brew.sh           | Homebrew on macOS/Linux, Sublime Text, misc CLI tools      | Large script; also symlinks misc configs (bat, fd)         |
| apt.sh            | APT packages (Debian-only)                                 | bc, fonts-firacode, less                                   |
| python.sh         | Python with pyenv, pip, linters (flake8, ruff, mypy, etc.) | Symlinks pip, yapf, ruff, mypy, proselint configs          |
| node.sh           | Node.js with fnm, npm default packages, completions        | Uses fnm (Fast Node Manager) instead of nvm                |
| go.sh             | Go with GOPATH setup, gopls, goimports, dlv, staticcheck   | Installs Go language server and dev tools                  |
| vim.sh            | Vim with vim-plug, ctags, linters (ALE)                    | Symlinks after, plugin, syntax dirs                        |
| ruby.sh           | Ruby with rbenv, ruby-build, bundler, rubocop              | Uses rbenv; installs default version 3.4.9                 |
| ssh.sh            | SSH config, host detection, control masters setup          | Creates ~/.ssh/hosts.d/ for host-specific configs          |
| dircolors.sh      | Dircolors themes (nord, bliss)                             | Links vendored theme files to ~/.dircolors/                |
| xdg-compliance.sh | XDG-compliant directories for less, wget, PostgreSQL       | Migrates legacy dot files to XDG locations                 |
| sops.sh           | SOPS + age secret encryption, age key generation           | XDG-compliant sops directory setup                         |
| glow.sh           | Glow markdown viewer                                       | Installs via brew or snap; symlinks config                 |
| ghostty.sh        | Ghostty terminal emulator (macOS trial setup)              | Also symlinks Everforest theme                             |
| terraform.sh      | Terraform with tfenv, terraform-docs, tfsec, checkov       | Installs latest Terraform version via tfenv                |
| extra.sh          | ~/.extra scaffolds for AI source templates                 | Creates skill-sources.example and steering-sources.example |

**Not invoked by install.sh:** dotnet.sh (installs .NET SDK), typora.sh (macOS-only Typora themes),
yt-dlp.sh (video downloader with config).

## How install.sh Invokes Scripts

Running `/install.sh` from the repository root:

1. Prompts for "Is this a work computer?" and writes result to `~/.extra/.env`
1. Sources scripts in this order (for correct dependency sequencing):
   - git.sh, zsh.sh, brew.sh, macos/apps.sh, apt.sh, python.sh, node.sh, go.sh, vim.sh, ruby.sh,
     ssh.sh, dircolors.sh, xdg-compliance.sh, sops.sh, glow.sh, ghostty.sh, terraform.sh, extra.sh
1. Sources `ai-dotfiles/install.sh` (from the standalone `~/.ai-dotfiles` repo, which is cloned if
   absent)
1. Runs `zunit` tests if available

Individual scripts can be re-run by sourcing them directly (e.g. `. install/python.sh`) to update
configurations without re-running the full install.

## Kubernetes Setup (install/kubernetes/)

The `kubernetes.sh` wrapper manages k3d cluster state (start/stop) before invoking
`install/kubernetes/setup.sh`, which sources `install/kubernetes/common.sh` for shared functions.
`common.sh` loads environment variables from `etc/kubernetes/.env` and sources `install/utils.sh`.
The `setup.sh` script installs k3d, kubectl, kubectx, helm, mkcert, creates a k3d cluster from
`etc/kubernetes/k3d-config.yaml`, and runs hooks in `install/kubernetes/hooks/` (e.g.
`configure-cert-manager.sh`). See `etc/kubernetes/README.md` for env template and cluster
configuration details.

## Adding a New Install Script

1. **Create `install/<tool>.sh`** — use `#!/bin/bash` with `set -euo pipefail` (the repo's shell
   convention; only some existing scripts set it)
1. **Source utils.sh if needed** — add `. "$DOTFILES_DIR/install/utils.sh"` for the logging and brew
   helpers below
1. **Check if installed** — use `is-executable <tool>` (from `bin/`) or, after sourcing `utils.sh`,
   `is_package_installed <pkg>` to skip redundant work
1. **Install if needed** — use `brew install` (macOS), `sudo apt install` (Debian), or
   package-manager-specific commands; wrap with `is-macos` / `is-debian` guards
1. **Create XDG directories** — mkdir -p `$XDG_CONFIG_HOME/<tool>` and `$XDG_DATA_HOME/<tool>` as
   needed
1. **Symlink configs** — use `ln -sfv` to link from `$DOTFILES_DIR/etc/<tool>/` to home/XDG
   locations
1. **Handle work/personal gating** — pass `work` or `personal` as the third argument to
   `install_if_needed <package> [type] [install_type]` to skip packages on mismatched computers
   (reads `$IS_WORK_COMPUTER` from `~/.extra/.env`)
1. **Add to install.sh** — insert the sourcing line in the correct order (usually after related
   tools)

## Helper Functions

`install/utils.sh` provides:

- **Logging**: `log_debug`, `log_info`, `log_warning`, `log_error`, `print_section_header`
- **Brew cache**: `init_brew_cache`, `refresh_brew_cache`, `is_package_installed`,
  `is_package_outdated`, `tap_if_needed`
- **Installation**: `install_if_needed` (with work/personal gating and auto-refresh)
- **Utilities**: `run_and_capture`, `strip_ansi`, `print_update_summary`

Platform detection helpers in `bin/`:

- `is-macos` — true on macOS
- `is-debian` — true on Debian/Ubuntu
- `is-executable <cmd>` — true if command exists in PATH
