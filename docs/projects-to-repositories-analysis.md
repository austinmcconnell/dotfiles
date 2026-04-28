# Project Directory Reorganization Analysis

## Status

Third-party repos have been moved to `~/sources/{owner}/{repo}` — that decision is closed.
`dotfiles sync-sources` and `SOURCES_DIR` env var are implemented on `main`.

The remaining question: should `~/projects` be renamed to `~/repositories`?

## Current State

```text
~/projects/                  # active development
├── austinmcconnell/         # ~33 personal repos (home machine, ~2 on work machine)
└── unite-us/                # work repos (work machine only)

~/sources/                   # third-party code (reference, forks, backups)
├── DeskPi-Team/
├── mattmc3/
└── ... (trimmed)
```

`~/projects` now contains only 2 owner directories. The original clutter problem (15+ dormant
third-party dirs) is solved.

## Motivation

The remaining question is conceptual: should `~/projects` become `~/repositories`?

**Arguments for renaming:**

- `~/repositories` is more descriptive — it's a directory of git repositories, not "projects"
- Aligns naming with `~/sources` (both describe what they contain, not what you do with them)
- Opportunity to flatten: drop the `{owner}/` level and put all repos directly under
  `~/repositories/` (since there are only 2 owners actively used)

**Arguments against:**

- `~/projects` works fine. Two owner directories is not clutter.
- Every path reference in dotfiles needs updating (~35 hardcoded references)
- Muscle memory and shell history will be wrong for weeks
- The original problem (visual clutter) is already solved

**Honest assessment:** This is purely about naming preference. There is no functional problem to
solve. The cost/benefit is even less favorable than the original clutter problem, which was itself
primarily aesthetic.

## Flattening Consideration

If renaming, there's a secondary question: keep `{owner}/{repo}` or flatten to just `{repo}`?

**Keep `{owner}/{repo}`:**

```text
~/repositories/
├── austinmcconnell/dotfiles
├── austinmcconnell/myproject
├── unite-us/screenings-ingestion
└── unite-us/web-app
```

- Consistent with `~/sources/{owner}/{repo}`
- No ambiguity if two owners have same repo name
- `git maintenance` paths, kiro-cli KBs, etc. just need a prefix swap

**Flatten to `{repo}`:**

```text
~/repositories/
├── dotfiles
├── myproject
├── screenings-ingestion
└── web-app
```

- Simpler navigation — one fewer directory level
- Breaks the `{owner}/{repo}` convention used everywhere else
- Repo name collisions become possible (unlikely but annoying)
- Every path reference changes shape, not just prefix — more error-prone

**Recommendation:** If renaming, keep `{owner}/{repo}`. Flattening adds risk for minimal benefit.

## Git Config: hasconfig Replaces gitdir

The current git config uses `includeIf "gitdir:~/projects/unite-us/"` to load work-specific
settings (email, signing key). This ties the config to the directory path.

Git 2.36+ (April 2022) introduced `hasconfig:remote.*.url:` — a condition that matches on remote
URL instead of filesystem path. Current git version is 2.54, so this is available.

**Current:**

```ini
[includeIf "gitdir:~/projects/unite-us/"]
    path = ./config-uniteus
```

**Proposed:**

```ini
[includeIf "hasconfig:remote.*.url:git@github.com:unite-us/**"]
    path = ./config-uniteus
```

This works because the `insteadOf` rules in git config rewrite all GitHub HTTPS URLs to SSH, so
every unite-us repo's effective remote is `git@github.com:unite-us/...`.

**Impact:** The git config becomes completely location-independent. Work repos can live anywhere —
`~/projects/unite-us/`, `~/repositories/unite-us/`, or blended alongside personal repos — and the
work email/signing key still applies automatically.

**Caveat:** `hasconfig` is slightly slower than `gitdir` (scans repo config for remote URLs vs.
checking path). In practice this is imperceptible.

**This change is valuable independent of any directory rename.** It should be done regardless.

## What Would Need to Change

If renaming `~/projects` → `~/repositories`:

### Shell-side (~1 line)

- `etc/zsh/.zshenv` — change `PROJECTS_DIR="$HOME/projects"` to
  `REPOSITORIES_DIR="$HOME/repositories"`. All shell scripts, Python scripts, `bin/dotfiles`
  commands, and completions already use the env var with fallback.
- Rename references from `PROJECTS_DIR` to `REPOSITORIES_DIR` across scripts for clarity.

### Git config (~4 references)

- `etc/git/config` — update `includeIf` (or switch to `hasconfig`, eliminating the path dependency)
- `etc/git/config` — update 3 `maintenance.repo` paths that use absolute paths

### Kiro-cli agent JSON (~27 references across 4 files)

- `default.json` — 8 path references (knowledge bases + allowedPaths)
- `docs.json` — 13 path references (knowledge bases + allowedPaths)
- `github.json` — 3 path references (allowedPaths)
- `jira.json` — 3 path references (allowedPaths)

No env var support — each is a manual find-and-replace.

### iTerm plist (~1 reference)

- `com.googlecode.iterm2.plist` — default directory `cd ~/projects`

### Dotfiles commands

- Rename `sync-projects` → `sync-repositories`
- Rename `analysis-status` → something consistent (e.g., `analysis-repositories`)
- Update help text, `sub_completion`, and `_dotfiles` completions

### Documentation (~7 references across 3 files)

- `docs/CustomizationGuide.md`, `.kiro/skills/` references

### Total: ~40 references across ~12 files

All mechanical find-and-replace. No architectural changes.

## Work Repos on Personal Machine (and Vice Versa)

A few `austinmcconnell/` repos exist on the work machine under `~/projects/austinmcconnell/`. With
`hasconfig:remote.*.url`, these can live anywhere without affecting git config. Options:

1. **Keep `{owner}/{repo}` structure** — `~/repositories/austinmcconnell/dotfiles` on both machines.
   Clean, consistent, no special cases.
1. **Blend into flat `~/repositories/`** — drop the owner prefix. Simpler but breaks convention.

Option 1 is the obvious choice. The owner directory serves as a natural namespace.

## Prior Work (Completed)

- `~/.repositories` cleanup — removed ~40 dead clones, migrated 3 live ones. Resolved naming
  collision with `~/repositories`. See commit history for details.
- `PROJECTS_DIR` env var — all shell-side references use `$PROJECTS_DIR` with fallback. A rename
  requires changing one line in `.zshenv`.
- `~/projects/scripts` relocated to `$DOTFILES_DIR/bin/`.
- Kiro-cli env var investigation — confirmed no env var support in agent JSON paths.
- `~/sources` separation — third-party repos moved, `SOURCES_DIR` env var and `sync-sources`
  command implemented.

## Cost of This Analysis

The preparatory work (env var migration, scripts relocation, kiro-cli investigation,
`~/.repositories` cleanup, `~/sources` separation) was useful independently but collectively
represents more engineering effort than the directory naming has ever cost in productivity. The
original clutter problem is solved. What remains is a naming preference.

## Recommendation

**Switch `includeIf` to `hasconfig:remote.*.url` now.** This is valuable regardless of any rename —
it decouples git config from directory structure. One-line change, zero risk.

**Don't rename `~/projects` to `~/repositories`.** The original problem (15+ cluttered directories)
is solved. Two owner directories under `~/projects` is clean and functional. Renaming ~40 references
across ~12 files for a naming preference is not worth the effort or the weeks of broken muscle
memory. The name `projects` is fine.

**If the naming still bothers you later**, the path is clear: change `.zshenv`, find-and-replace
across kiro-cli JSON and git config, update iTerm plist. The `hasconfig` migration (recommended
above) removes the git config from the critical path, making a future rename even cheaper.
