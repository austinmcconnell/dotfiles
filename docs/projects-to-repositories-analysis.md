# Project Directory Reorganization Analysis

## Status

Open decision. No restructuring has been done to `~/projects`. Prerequisite work completed:

- `~/.repositories` cleanup (see Prior Work below)
- `PROJECTS_DIR` env var introduced — shell scripts, commands, and docs now use `$PROJECTS_DIR`
  instead of hardcoded `~/projects` (see Preparatory Work below)
- `~/projects/scripts` relocated to `$DOTFILES_DIR/bin/` — `~/projects` is now purely
  `{owner}/{repo}`

## Motivation

All git repositories currently live under `~/projects/{owner}/{repo}`. The primary working directory
is `~/projects/austinmcconnell/` (~33 repos). Roughly 15 other owner directories (third-party forks,
references) sit alongside it and are rarely touched. The goal is to simplify the primary working
directory by reducing clutter.

## Key Constraint

Any path change will be applied to both personal and work machines simultaneously. There is no need
to maintain backward compatibility with `~/projects`.

## Current Directory Structure

```text
~/projects/
├── austinmcconnell/     # ~33 personal repos (primary workspace)
├── unite-us/            # work repos (work machine only)
├── DeskPi-Team/         # third-party forks/references
├── Shrike-Lab/
├── fathulfahmy/
├── geerlingguy/
├── mattmc3/
├── ... (~10 more owner dirs)
```

## How ~/projects Paths Are Used Across Dotfiles

Most shell-side references now use `$PROJECTS_DIR` (defined in `.zshenv`). The remaining hardcoded
`~/projects` references are in files that don't support env var expansion.

### Now using $PROJECTS_DIR (updated)

- `bin/dotfiles` — `sync-projects` and `analysis-status` use `${PROJECTS_DIR:-$HOME/projects}`
- `scripts/*.py` — 5 Python scripts read `PROJECTS_DIR` env var with `$HOME/projects` fallback
- `scripts/*.sh` — `analyze-git-repos.sh` and `scan-docs.sh` use `$PROJECTS_DIR` as default
- `etc/zsh/completions/_dotfiles` — descriptions reference `$PROJECTS_DIR`

### Still hardcoded (no env var support)

- `etc/git/config` — `includeIf "gitdir:~/projects/unite-us/"` loads work-specific git config
- `etc/iterm/com.googlecode.iterm2.plist` — default directory `cd ~/projects`
- `etc/kiro-cli/cli-agents/default.json` — 4 knowledge bases pointing to `~/projects/`
- `etc/kiro-cli/cli-agents/docs.json` — 10 knowledge bases pointing to `~/projects/austinmcconnell/`
- `allowedPaths` in all 4 agent JSON files — `~/projects/**` (kiro-cli doesn't support env vars in
  these fields)

### Resolved

- `etc/zsh/.zprofile` — `~/projects/scripts` PATH entry removed (symlinks moved to
  `$DOTFILES_DIR/bin/`)
- `install/scripts.sh` — now symlinks into `$DOTFILES_DIR/bin/` instead of `~/projects/scripts`

## Options Considered

### Option A: Do Nothing (alias)

Add `alias p="cd ~/projects/austinmcconnell"` and stop thinking about it.

- **Tradeoff:** Zero file changes, zero risk. Doesn't actually reduce clutter — just avoids looking
  at it. The third-party directories still exist and still get synced by `dotfiles sync-projects`.

### Option B: Archive Cold Repos

Move third-party repos to `~/projects/_archive/{owner}/{repo}`.

- **Tradeoff:** Minimal changes. The leading underscore sorts them out of the way. `sync-projects`
  still finds them (same `*/*` glob) unless explicitly excluded. Doesn't change the top-level
  directory structure.

### Option C: Reference Subdirectory

Move third-party repos to `~/projects/_reference/{owner}/{repo}`.

- **Tradeoff:** Same mechanics as Option B with clearer intent naming. Can optionally filter
  `_reference` out of `sync-projects` and `analysis-status`.

### Option D: Full Split

Move personal repos to `~/repositories/` (or similar). Keep `~/projects` for work repos, or
eliminate it entirely.

- **Tradeoff:** Cleanest end state — primary workspace is a top-level directory with no clutter.
  Requires updating ~25 files with ~60 path references. Since both machines update simultaneously,
  there's no compatibility concern, but it's a large mechanical change.

## Key Blockers for a Full Split

1. **Knowledge base paths are hardcoded:** 14 knowledge base entries across `default.json` and
   `docs.json` use absolute paths like `file://~/projects/austinmcconnell/_research_`. Kiro-cli does
   not support env var expansion in `resources` or knowledge base `source` fields. Each would need
   manual updating.

1. **`allowedPaths` are hardcoded:** All 4 agent JSON files reference `~/projects/**`. Same
   limitation — no env var support.

1. **Git `includeIf` coupling:** `gitdir:~/projects/unite-us/` loads work git config. If work repos
   move too, this path must update. Straightforward but easy to miss.

1. **iTerm plist:** Default directory `cd ~/projects` is baked into the binary plist.

1. ~~**Volume of changes:** ~60 references across ~25 files.~~ Reduced by `PROJECTS_DIR` env var.
   Shell scripts and commands now require only a one-line `.zshenv` change. Remaining cost is ~20
   hardcoded references in kiro-cli agent JSON, git config, and iTerm plist.

1. ~~**`~/projects/scripts` is on PATH.**~~ Resolved — symlinks moved to `$DOTFILES_DIR/bin/`.

## Prior Work (Completed)

The `~/.repositories` directory previously held ~40 git clones (vim plugins, dircolors themes,
github-mcp-server). Investigation revealed 37 were dead (orphaned by the vim-plug migration in March
2024\) and 3 were alive. All three were migrated to better approaches:

- **Dircolors themes** — vendored into `etc/dircolors/` (committed files, symlinked by install
  script)
- **github-mcp-server** — switched to `go install` (binary goes to `$GOPATH/bin`, already on PATH)
- **~/.repositories infrastructure** — fully removed (REPO_DIR export, update-repos command,
  completions, mkdir in install.sh, documentation references)

This cleanup eliminated the naming collision that would have existed between `~/.repositories`
(hidden, tools) and `~/repositories` (visible, personal repos) in the original proposal.

## Preparatory Work (Completed)

Independent improvements that reduce the cost of a future move without committing to one:

### PROJECTS_DIR env var

Added `export PROJECTS_DIR="$HOME/projects"` to `.zshenv` (matching the existing `DOTFILES_DIR`
pattern). Updated all shell scripts, Python scripts, `bin/dotfiles` commands, completions, and
documentation to use `$PROJECTS_DIR` (with `$HOME/projects` fallback). A future directory rename now
requires only changing the one-line export in `.zshenv` for all shell-side references.

### ~/projects/scripts relocated

Moved script symlinks from `~/projects/scripts/` to `$DOTFILES_DIR/bin/` (already on PATH). Removed
the `~/projects/scripts` PATH entry from `.zprofile` and the `mkdir -p` from `install/scripts.sh`.
`~/projects` is now purely `{owner}/{repo}` directories.

### Kiro-cli env var investigation

Confirmed that kiro-cli does **not** support env var expansion in `resources`, knowledge base
`source` paths, or `allowedPaths`/`deniedPaths` in `toolsSettings`. The `${VAR}` syntax only works
in MCP server `env` blocks. The ~20 hardcoded `~/projects` references in agent JSON files are the
irreducible manual cost of any future path change.

## Recommendation

Options A–C are low-effort and low-risk. Option D produces the cleanest result but requires a
focused session of mechanical file updates.

Given that both machines update simultaneously (no backward compatibility needed) and the
`~/.repositories` naming collision is resolved, Option D is more viable than initially assessed. The
blockers are purely mechanical — no architectural obstacles remain.

If the clutter is a minor annoyance, Option A (alias) is the pragmatic choice. If it's a genuine
friction point in daily work, Option D is worth the one-time cost of updating ~25 files.

## Future Investigation Areas

### Smart Directory Navigation

Tools like zoxide or autojump learn frequently-used directories and let you jump to them with
partial matches (e.g., `z austin` → `~/projects/austinmcconnell`). If the core problem is "too many
`ls` results when I cd to ~/projects," a directory jumper may eliminate the need for any
restructuring.

### Work Repo Separation

The git `includeIf "gitdir:~/projects/unite-us/"` ties work git config to a specific path. Evaluate
whether work repos should have their own top-level directory (e.g., `~/work/`) independent of
personal repos, which would decouple the git config from any personal repo reorganization.
