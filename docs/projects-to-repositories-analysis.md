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
is `~/projects/austinmcconnell/` (~33 repos) at home and `~/projects/unite-us/` at work. Roughly 15
other owner directories (third-party forks, references) sit alongside them and are rarely — if
ever — touched.

`~/projects` is central to daily workflow: `cd ~/projects/{owner}/{repo}` (often with tab
completion) happens dozens of times a day. The ~15 dormant owner directories create visual noise in
`ls` and `tree` output and make the directory feel cluttered.

**Honest assessment:** This is primarily about conceptual tidiness — wanting the directory structure
to reflect what's actively used — rather than a measurable productivity bottleneck. Tab completion
and muscle memory mean the extra directories rarely cause wrong-directory mistakes. The friction is
aesthetic, not mechanical. That's a valid reason to reorganize, but it should be weighed against the
cost of each option accordingly.

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

Move third-party repos to `~/projects/_reference/{owner}/{repo}`. Everything except
`austinmcconnell/` and `unite-us/` moves.

**Implementation sketch:**

```bash
# Create _reference and move all third-party owner dirs
mkdir -p ~/projects/_reference
for dir in ~/projects/*/; do
    name=$(basename "$dir")
    [[ "$name" == "austinmcconnell" || "$name" == "unite-us" || "$name" == _* ]] && continue
    mv "$dir" ~/projects/_reference/
done
```

**What changes in dotfiles (~3 files):**

- `bin/dotfiles` — update `sync-projects` and `analysis-status` globs from `"$projects_dir"/*/*` to
  `"$projects_dir"/*/*` plus `"$projects_dir"/_reference/*/*` (or switch to `find -maxdepth 3` to
  catch both levels). Alternatively, exclude `_reference` from these commands entirely since those
  repos are rarely updated.
- No changes needed to `$PROJECTS_DIR`, kiro-cli agent paths, git config, or iTerm plist — the
  `austinmcconnell/` and `unite-us/` paths are unchanged.

**Result:**

```text
~/projects/
├── austinmcconnell/     # ~33 personal repos
├── unite-us/            # work repos
└── _reference/          # everything else
    ├── DeskPi-Team/
    ├── Shrike-Lab/
    ├── fathulfahmy/
    ├── geerlingguy/
    ├── mattmc3/
    └── ... (~10 more)
```

- **Tradeoff:** ~10 minutes of work. `ls ~/projects` drops from ~17 entries to 3. Delivers most of
  the decluttering benefit of Option D with almost none of the cost. The leading underscore sorts
  `_reference` to the top, visually separating it. The only downside: `sync-projects` needs a small
  glob adjustment if you want it to keep syncing reference repos.

### Option D: Full Split

Move personal repos to `~/repositories/` (or similar). Keep `~/projects` for work repos, or
eliminate it entirely.

- **Tradeoff:** Cleanest end state — primary workspace is a top-level directory with no clutter.
  Requires updating ~25 files with ~60 path references. Since both machines update simultaneously,
  there's no compatibility concern, but it's a large mechanical change.

### Option E: Smart Directory Navigation (zoxide)

Install [zoxide](https://github.com/ajeetdsouza/zoxide), a smarter `cd` that learns your
frequently-used directories. After a short learning period, `z screenings` jumps straight to
`~/projects/unite-us/screenings-ingestion` — no tab completion, no intermediate `cd` hops.

- **What changes:** Install zoxide (`brew install zoxide`), add the shell init to `.zshrc`, use it
  for a week. Zero path changes, zero file edits beyond shell config.
- **What it solves:** Eliminates the "cd to ~/projects, then cd deeper" pattern entirely. The ~15
  dormant directories become invisible because you never traverse through `~/projects/` manually.
- **What it doesn't solve:** The directories still exist. `ls ~/projects` still shows clutter. If
  the motivation is purely conceptual tidiness, this doesn't address it.
- **Tradeoff:** Near-zero cost to try. If it eliminates the navigation friction, the remaining
  motivation (conceptual tidiness) may not justify the cost of Options C or D. Worth trying before
  committing to a restructure.

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

`~/.repositories` previously held ~40 git clones (vim plugins, dircolors themes, github-mcp-server).
All were migrated or removed — see commit history for details. This resolved the naming collision
that would have existed between `~/.repositories` and `~/repositories` in the original Option D
proposal.

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

## Cost of This Analysis

The preparatory work above (env var migration, scripts relocation, kiro-cli investigation,
`~/.repositories` cleanup) was useful independently but collectively represents more engineering
effort than the directory clutter has ever cost in lost productivity. This is worth acknowledging
when evaluating whether Options C or D are justified: the analysis itself has already exceeded the
likely lifetime cost of the problem.

## Recommendation

**Try Option E (zoxide) first.** It's near-zero cost and directly addresses the navigation pattern.
If the clutter stops bothering you once you're never traversing `~/projects/` manually, stop there.

**If conceptual tidiness still matters, do Option C.** It delivers ~80% of the decluttering benefit
(17 entries → 3) in ~10 minutes of work, with no impact on kiro-cli paths, git config, or iTerm.
This is the best cost/benefit ratio of any structural change.

**Option D remains viable but hard to justify.** The blockers are purely mechanical, and both
machines update simultaneously. But given that the motivation is aesthetic rather than a productivity
bottleneck — and the analysis prep work has already exceeded the likely lifetime cost of the
problem — the one-time cost of ~25 file updates is disproportionate to the incremental benefit over
Option C.

## Future Investigation Areas

### Work Repo Separation

The git `includeIf "gitdir:~/projects/unite-us/"` ties work git config to a specific path. Evaluate
whether work repos should have their own top-level directory (e.g., `~/work/`) independent of
personal repos, which would decouple the git config from any personal repo reorganization.
