# etc

Configuration files, one directory per tool. Files here are not read from this location; an install
script symlinks them into `$XDG_CONFIG_HOME` or the home directory, so edit them here and the change
shows up in the live path. The "Installed by" column names the script in `install/` that creates the
link. To add a tool, see "Adding a New Tool Configuration" in `AGENTS.md`.

Directories marked with a README have their own, with the architecture and conventions for that
tool.

## Large configurations

| Directory       | Contents                                                         | Installed by                  |
| :-------------- | :--------------------------------------------------------------- | :---------------------------- |
| `zsh/`          | Zsh startup files, `conf.d/`, functions, completions (README)    | `install/zsh.sh`              |
| `vim/`          | `.vimrc`, per-plugin config, ftplugins, syntax (README)          | `install/vim.sh`              |
| `git/`          | Git config, hooks, attributes, commit template (README)          | `install/git.sh`              |
| `kubernetes/`   | k3d cluster, helmfile, chart values, bats tests (README)         | `install/kubernetes/setup.sh` |
| `python/`       | Ruff and other Python tool configs (README)                      | `install/python.sh`           |
| `ssh/`          | SSH config and the `hosts.d/` machine-specific includes (README) | `install/ssh.sh`              |
| `ruby/`         | gemrc, irbrc, rubocop, default gems                              | `install/ruby.sh`             |
| `sublime-text/` | Sublime Text settings, keymap and LSP config                     | `install/brew.sh`             |
| `terminfo/`     | tmux and xterm terminfo definitions                              | `install/zsh.sh`              |

## Single-tool configurations

| Directory    | Contents                            | Installed by           |
| :----------- | :---------------------------------- | :--------------------- |
| `bat/`       | bat config                          | `install/brew.sh`      |
| `dircolors/` | nord and bliss dircolors themes     | `install/dircolors.sh` |
| `direnv/`    | direnv config                       | `install/zsh.sh`       |
| `dprint/`    | dprint formatter config             | `install/brew.sh`      |
| `fd/`        | fd ignore file                      | `install/brew.sh`      |
| `gh/`        | GitHub CLI config                   | `install/brew.sh`      |
| `ghostty/`   | Ghostty config and themes           | `install/ghostty.sh`   |
| `glow/`      | glow config and `nord.json`         | `install/glow.sh`      |
| `httpie/`    | HTTPie config                       | `install/brew.sh`      |
| `iterm/`     | iTerm2 preferences plist and keymap | `install/zsh.sh`       |
| `misc/`      | hadolint and shellcheck config      | `install/brew.sh`      |
| `node/`      | default global npm packages         | `install/node.sh`      |
| `ripgrep/`   | ripgrep config                      | `install/vim.sh`       |
| `rumdl/`     | rumdl markdown linter config        | `install/brew.sh`      |
| `sops/`      | sops config                         | `install/sops.sh`      |
| `spaceship/` | Spaceship prompt config             | `install/zsh.sh`       |
| `starship/`  | Starship prompt config              | `install/zsh.sh`       |
| `terraform/` | terraform rc file                   | `install/terraform.sh` |
| `vale/`      | vale prose linter config            | `install/brew.sh`      |
| `yaml/`      | yamllint config                     | `install/vim.sh`       |
| `yt-dlp/`    | yt-dlp config                       | `install/yt-dlp.sh`    |

## Not linked by an install script

| Directory | Contents                            | How it is used                                                          |
| :-------- | :---------------------------------- | :---------------------------------------------------------------------- |
| `taplo/`  | taplo TOML formatter config         | Passed as `--config` by hooks in `.pre-commit-config.yaml`              |
| `nuphy/`  | NuPhy Air75 V2 keyboard layout JSON | Not referenced by any script                                            |
| `typora/` | Typora export settings notes        | Not linked; `install/typora.sh` exists but `install.sh` does not run it |
