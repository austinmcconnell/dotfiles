# Scripts

Helper scripts for maintenance, analysis, and one-off automation. Unlike `bin/`, nothing here is on
`PATH`; scripts are run by path. Most are manual utilities. Only the four scripts in "Wired into the
repo" are called by other parts of the repo.

## Wired into the repo

| Script               | Called by                                                                        |
| :------------------- | :------------------------------------------------------------------------------- |
| `sort-git-config.sh` | The "Sort git config" hook in `.pre-commit-config.yaml`; see `etc/git/README.md` |
| `pip_orphans.py`     | `dotfiles orphans` (`sub_orphans` in `bin/dotfiles`)                             |
| `gem_orphans.rb`     | `dotfiles orphans` (`sub_orphans` in `bin/dotfiles`)                             |
| `ai-prompt.sh`       | Sourced by `etc/zsh/conf.d/ai-prompts.zsh`                                       |

## Manual utilities

Run by path, e.g. `scripts/analyze-git-repos.sh [directory]` or `python3 scripts/<name>.py`. No
caller was found for any script in this table.

| Script                             | Purpose                                                                          |
| :--------------------------------- | :------------------------------------------------------------------------------- |
| `analyze-git-repos.sh`             | Scan repos and recommend `git maintenance` registration                          |
| `migrate_git_repositories.py`      | Migrate repos under `$PROJECTS_DIR` to the reftable ref format                   |
| `reinitialize_git_repositories.py` | Re-create hooks and default branch in repos under `$PROJECTS_DIR`                |
| `convert-github-remotes-to-ssh.py` | Convert GitHub HTTPS remotes to SSH                                              |
| `sort_git_repos_by_owner.py`       | Move repos into an `owner/repo` directory layout                                 |
| `configure_env_and_leave_files.py` | Add venv activate/deactivate env files to repos (assumes the owner layout)       |
| `generate-vim-mappings-doc.sh`     | Extract mappings from `etc/vim/plugin/` into `docs/VimMappings.md`               |
| `scan-docs.sh`                     | Report status of documentation repos (default `$PROJECTS_DIR/_documentation_`)   |
| `convert-pylint-to-ruff.sh`        | Rewrite pylint disable comments as ruff `noqa` (`[--yes]`, current directory)    |
| `sort_docker_compose.py`           | Reorder Docker Compose YAML keys into a canonical order                          |
| `compare-env.sh`                   | Compare `.env` against an example env file: missing, extra, differing variables  |
| `fix-photo-dates.sh`               | Set file dates from EXIF data; dry-run unless `--apply` (needs `exiftool`, `jq`) |
| `verify-certs.sh`                  | Fetch and verify a hostname's TLS certificate chain with `openssl`               |
| `find-command-in-path.sh`          | List every `PATH` location of a command                                          |

## System alerts

For use from an external scheduler (cron or launchd). Nothing in this repo installs or schedules
them.

| Script                  | Behavior                                                        |
| :---------------------- | :-------------------------------------------------------------- |
| `high-cpu-alert.sh`     | Prints `1` if CPU usage is above 50%, otherwise `0`             |
| `high-memory-alert.sh`  | Prints `1` if free memory is below 30%, otherwise `0`           |
| `free-space-alert.scpt` | AppleScript free-disk-space check for the "Macintosh HD" volume |
