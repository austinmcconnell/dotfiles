# AI Tooling Extraction Contract

The AI tooling in this repo (agents, skills, steering, prompts, hooks, and their install scripts) is
**decoupled in place**: it lives inside `~/.dotfiles` today but is written so it *could* be
extracted into a standalone repo later without a rewrite. This document records the contract that
extraction would rely on — what already relocates cleanly, and what still needs to travel with or be
replaced.

Nothing here is a required action while colocated. It is a checklist for a future extraction.

## The `AI_DOTFILES_DIR` mechanism

All AI tooling resolves its own root through the `AI_DOTFILES_DIR` environment variable:

- Exported in `etc/zsh/.zshenv`: `export AI_DOTFILES_DIR="${AI_DOTFILES_DIR:-$DOTFILES_DIR}"`
- Defaults to `$DOTFILES_DIR` (`~/.dotfiles`) while colocated, so behavior is unchanged.
- A standalone extraction sets `AI_DOTFILES_DIR=~/wherever` before running the AI install scripts,
  and everything resolves against that root instead.

To relocate: set `AI_DOTFILES_DIR`, move the `etc/ai/`, `etc/kiro-cli/`, `etc/claude-code/`,
`etc/codex/`, `etc/cursor/` trees and the `install/` AI scripts under the new root, then run the
install scripts. The pieces below are what that move must account for.

## What already relocates cleanly

These were converted during the in-place decoupling and follow `AI_DOTFILES_DIR` with no further
work:

- **Install scripts** — `install/ai-tools.sh`, `kiro-cli.sh`, `claude-code.sh`, `codex.sh`,
  `cursor.sh`, `engram.sh` are self-locating (`AI_DOTFILES_DIR` falls back to their own
  `dirname/..`) and use `$AI_DOTFILES_DIR` for every `etc/` path and the `utils.sh` source.
- **kiro-cli agent hook commands** — reference `$AI_DOTFILES_DIR/etc/...` (shell-expanded at
  runtime; kiro inherits the exported var).
- **kiro-cli steering resources** — reference `file://~/.kiro/steering/...`, and
  `install/ai-tools.sh` symlinks `$AI_DOTFILES_DIR/etc/ai/steering` → `~/.kiro/steering`. The
  relocation anchor is `~/.kiro`, so agent JSONs never change.
- **Claude Code hook commands** — reference `$AI_DOTFILES_DIR/etc/...` (Claude Code runs shell-form
  hooks via `sh -c` and inherits the exported var).
- **Generated steering headers** — `install/ai-tools.sh` emits `$STEERING_SOURCE` (=
  `$AI_DOTFILES_DIR/etc/ai/steering`) into the generated CLAUDE.md / GEMINI.md pointer text.
- **`ai-prompt` zsh glue** — `ai-prompts.zsh`, `scripts/ai-prompt.sh`, and the `_ai-prompt`
  completion resolve prompts from `${AI_DOTFILES_DIR:-$HOME/.dotfiles}/etc/ai/prompts`.

## What must travel with an extraction

### 1. `bin/` helper scripts (PATH dependency)

The AI install scripts call three helpers that are **not** functions in `install/utils.sh` — they
are standalone executables in `bin/`, on `PATH` only because `etc/zsh/.zprofile` adds
`$DOTFILES_DIR/bin`:

| Helper          | Used by          | Behavior                            |
| --------------- | ---------------- | ----------------------------------- |
| `is-executable` | engram, kiro-cli | `type "$1"` — is a command on PATH? |
| `is-macos`      | (cross-platform) | `$OSTYPE =~ ^darwin`                |
| `is-debian`     | (cross-platform) | `$OSTYPE == linux-gnu`              |

Each is a ~4-line bash script. An extraction must either carry `bin/is-executable` (plus `is-macos`
/ `is-debian` if the Linux install branch in `kiro-cli.sh` is kept) and put them on PATH, or inline
their logic. Without them, the install fails with `is-executable: command not found`.

### 2. `install/utils.sh` surface

The AI install scripts use three functions from `utils.sh`:

- **`print_section_header`** — self-contained (just prints a formatted header, gated on
  `LOG_LEVEL`). Trivial to carry.
- **`init_brew_cache`** — called **directly** by `install/kiro-cli.sh` and `install/claude-code.sh`
  before their `install_if_needed` call, and also called internally by `install_if_needed`. It
  populates the `BREW_*` module globals from `brew list`/`brew outdated` and caches them to
  `$HOME/.cache/dotfiles/brew_cache`. Depends on Homebrew and `gstat`/`stat`.
- **`install_if_needed`** — installs the tool's Homebrew cask (claude-code, codex, kiro-cli). This
  one is **heavy**: it sources `$HOME/.extra/.env` (for `IS_WORK_COMPUTER`, and exits 1 if the file
  is missing) and transitively depends on the brew-cache subsystem (`init_brew_cache`,
  `is_package_installed`, `is_package_outdated`, `refresh_brew_cache`, and the `BREW_*` module
  globals) plus Homebrew itself.

For an extraction, carrying `print_section_header` verbatim is fine. `init_brew_cache` and
`install_if_needed` are better **replaced** together with a minimal `brew install --cask <tool>`
(guarded by an `is-executable`/`brew list` check) than carried with their whole
cache-and-`.extra/.env` machinery, which is dotfiles-bootstrap infrastructure unrelated to AI
tooling. Note the two direct `init_brew_cache` calls in `kiro-cli.sh` and `claude-code.sh` must be
removed alongside `install_if_needed` — carrying only `print_section_header` would leave those calls
undefined.

### 3. Workspace-access grants (repoint, don't remove)

The agent configs grant the agent read/write access to the dotfiles working directory via
`~/.dotfiles/**` patterns:

- kiro agent JSONs: `~/.dotfiles/**` in `write`/`grep`/`glob`/`read` `allowedPaths` (V2) and
  `fs_write`/`fs_read` `permissions.rules` matches (V3)
- `etc/claude-code/settings.json`: `Edit(~/.dotfiles/**)`
- `etc/cursor/cli-config.json`: `Write(~/.dotfiles/**)`

These are **workspace grants** (they let the agent edit the config repo), semantically distinct from
install-path coupling. On extraction, repoint them at wherever the config repo lives (or add the new
repo path). They do not break the tooling if left as-is — the agent just wouldn't have write access
to the new location.

## What is intentionally machine-specific (leave as-is)

These reference personal repos that are absent on other machines. They are intentional and guarded
(kiro-cli.sh uses `[ -d ... ]` checks and non-fatal clone failures); a knowledge base pointing at a
missing repo simply returns no results. Do not "fix" them for extraction:

- `install/kiro-cli.sh`: `RESEARCH_REPO="$HOME/projects/austinmcconnell/_research_"` and
  `SOURCES_DIR="$HOME/sources/geerlingguy"` (locally redefined; personal-repo setup).
- `knowledgeBase` `source` URIs in agent JSONs pointing at `~/projects/...` and `~/sources/...`.

## Out of scope (not AI tooling)

- `etc/zsh/conf.d/fpath.zsh` uses `$DOTFILES_DIR` to autoload all zsh functions — general shell
  glue, not AI-specific.
- `etc/ai/prompts/*.md` prose references `~/.dotfiles/...` in a few instructional prompts (e.g.
  `vim-practice-session.md` points at vim/obsidian paths). These are human/agent-facing
  instructions, not executed paths; update opportunistically if extracted.

## Extraction checklist (summary)

1. Set `AI_DOTFILES_DIR` to the new root before running install scripts.
1. Move `etc/ai/`, `etc/kiro-cli/`, `etc/claude-code/`, `etc/codex/`, `etc/cursor/` and the AI
   `install/*.sh` scripts.
1. Carry `bin/is-executable` (+ `is-macos`/`is-debian` if keeping the Linux branch), or inline them.
1. Carry `print_section_header`; replace `install_if_needed` (and the direct `init_brew_cache` calls
   in `kiro-cli.sh`/`claude-code.sh`) with a minimal brew-install helper.
1. Repoint `~/.dotfiles/**` workspace grants at the new repo location.
1. Leave machine-specific `~/projects` / `~/sources` KB and repo paths as-is.
1. Run the AI install scripts and verify: agents load, hooks fire (`recall-memory.sh`,
   `block-env-files.sh`), steering loads via `~/.kiro/steering`, and `ai-prompt list` works.
