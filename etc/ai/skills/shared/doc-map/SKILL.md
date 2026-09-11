---
name: doc-map
description: Navigate a project's documentation via an optional AGENTS.md Document Map section, treating it as a map of one-hop pointers to detailed docs and falling back to the nearest README then grep/glob when absent. Use when exploring an unfamiliar project, looking for documentation on a topic, deciding whether a doc exists before searching, or authoring a doc map that should point to detailed docs.
---

# Document Map

## Purpose

A **doc map** is a thin, always-relevant index of the important docs in a project — not the docs
themselves. It names the specific detailed doc to read for a given topic, so the agent can pull the
right document on demand instead of eager-loading a whole `docs/` tree.

The map lives as an optional `## Document Map` section inside `AGENTS.md`. That file is already
eager-loaded on every kiro agent, so a map placed there *is* in context with no extra hop — the map
IS the eager artifact, it does not point at a separate one. Eager-loading whole documentation trees
measurably degrades answer accuracy (context rot) before the window is even full; the doc-map model
keeps the eager layer thin (a signpost inside a file that's already loaded) while the detailed docs
live in the retrieval channel, fetched with `read`/`grep` only when a pointer says they are
relevant.

The map is **optional per-repo**. Most repositories will not have one, and that is fine — the
navigation steps below degrade cleanly when it is absent.

## How to navigate (reading)

When exploring a project or looking for documentation on a topic, orient in this order:

1. **Read the `## Document Map` section of `AGENTS.md` first, if present.** Treat it as an index of
   what documentation exists here, not as the full answer. It names the target doc for a topic and
   when to read it.
1. **Follow one-hop pointers to the target doc.** A pointer names an actual detailed doc
   (`docs/<topic>.md`), not another map or README. Read that target doc directly with `read`.
1. **Do not chain map → README → doc.** Agents reliably follow a single plain-text pointer but bail
   on chained ones. If a pointer names a directory rather than a doc, look for a direct pointer to
   the target; don't hop through a second index expecting it to relay you further.
1. **Fall back when there is no map or no matching pointer.** If `AGENTS.md` has no
   `## Document Map` section (the common case), or the map has no entry for the topic, read the
   nearest `README.md` as a map, then use `grep`/`glob` to locate docs directly, or the knowledge
   base if the repo is indexed. A missing pointer means "not mapped," not "does not exist."

## How to author (writing a doc map)

When adding or updating a project's doc map:

- **Place it as a `## Document Map` section in `AGENTS.md`.** Do not create a separate map file and
  point at it from `AGENTS.md` or `README.md` — a referenced map rebuilds the two-hop chain the
  scheme exists to avoid. The map must live in the file that is already eager-loaded.
- **One line per important doc**, naming the file and when to read it — e.g.
  `- <topic>: <path> — read when <situation>`.
- **One-hop rule (hard constraint):** each pointer names the *actual target doc*, never another map
  or README. If a chain is genuinely unavoidable, use a mechanical include, not a plain-text pointer
  — only mechanical includes chain reliably.
- **Flat, not deep (hard constraint):** one level of indexing. Do not build a tree of nested index
  files that re-creates context pressure — deeper hierarchy hurts navigation, it does not help.
- **High-signal only.** Name the docs a reader would actually need to find. A map that lists
  everything is as useless as one that lists nothing.
- **Optional per-repo.** Only add a map when a repo has enough high-value docs that discovery is a
  real problem. A repo whose docs are trivially discoverable does not need one.

## Narrow exception: eager-loading a doc

The default is to point, not preload. Expand a pointer into a full eager-load (a `file://<path>`
resource entry, kiro-cli only) *only* for a single small, stable, high-signal doc where
whole-document reasoning genuinely helps every session — e.g. a compact architecture overview. This
is a deliberate, named per-repo exception, never a `file://docs/*.md` glob. When in doubt, point.

## Tool parity

- **kiro-cli** eager-loads `AGENTS.md` (and `README.md`) on every agent via each agent's
  `file://AGENTS.md` resource, so a `## Document Map` section is already in context — no config
  change is needed to host a map. The docs it points at are pulled on demand with `read`/`grep`.
- **Claude Code** has no per-project relative `resources` mechanism, so nothing auto-loads — this
  skill *is* the parity mechanism. On entering a project, read the `## Document Map` section of
  `AGENTS.md` first (if present), else the nearest `README.md` as a map, and follow its one-hop
  pointers, exactly as above. Functional (skill-driven) coverage, not automatic (context-preloaded).
