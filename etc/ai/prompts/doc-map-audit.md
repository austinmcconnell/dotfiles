# Doc Map Audit

**IMPORTANT: Branch Validation Required** Before proceeding, verify the current git branch:

```bash
git branch --show-current
```

This audit should ONLY be performed on `main` or `master` branches. If currently on a different
branch, abort and inform the user that the doc-map audit should be done from the main branch.

**Read the convention first:** This audit APPLIES the `doc-map` skill at repo scale — it does not
restate the rules. Read `~/.kiro/skills/shared/doc-map/SKILL.md` (or
`~/.dotfiles/etc/ai/skills/shared/doc-map/SKILL.md`) before proposing any map, and obey its hard
constraints when authoring: **one-hop** (a pointer names the actual target doc, never another map or
README), **flat, not deep** (one level of indexing — do NOT create nested index trees), and
**high-signal only** (name the docs a reader would actually need, not every file).

**Doc Map Audit:** Survey how well this repository's documentation is reachable via the doc-map
scheme, then populate missing pointers under a chosen cadence. The scheme's primary map is an
optional `## Document Map` section inside the already-eager `AGENTS.md`; the nearest `README.md`
serves as the fallback map when no such section exists. The goal is that a reader (human or agent)
can find any important doc by reading the doc map — without eager-loading a `docs/` tree.

Note the map is **optional per-repo**: a repo whose docs are trivially discoverable does not need
one, and "recommend no map" is a valid audit outcome. Do not manufacture a map for a repo that does
not warrant it.

## Phase 1 — Inventory & Gap Report (always; read-only)

This phase is non-destructive and is the discovery mechanism that defuses the chicken-and-egg
problem of opportunistic population: it finds EVERY orphaned doc up front so later population works
from a known, ranked worklist instead of waiting to stumble onto a gap.

1. **Enumerate docs.** Find every `.md` (and `.rst`/`.adoc` if present), excluding vendored/build
   paths (`node_modules`, `.git`, `dist`, `build`, `.venv`, `target`).
1. **Locate the maps.** Check `AGENTS.md` for a `## Document Map` section (the primary map). Then
   find every `README.md` and note its directory level (the fallback map tier).
1. **Map coverage.** Parse the pointer lines in the `## Document Map` section (if present) and each
   README, and record which docs they name. For each non-map doc, determine whether the doc map or
   the nearest README points at it.
1. **Rank the gaps.** Produce a table of orphaned docs (docs no map points at), ranked by
   importance. Approximate importance with:
   - proximity to root (root and top-level dirs rank highest),
   - change frequency (`git log` touch count — frequently-edited docs are high-traffic),
   - whether the doc sits in a recognized docs location (`docs/`, `doc/`, subsystem dirs).
1. **Flag violations of the scheme**, not just absences:
   - map → map or map → README pointers (breaks the one-hop rule),
   - nested index trees (breaks the flat rule),
   - pointers to docs that no longer exist (dangling),
   - over-listing (a map that indexes low-signal noise),
   - a separate map file referenced from `AGENTS.md`/`README.md` instead of an inline
     `## Document Map` section (rebuilds the forbidden two-hop chain).

**Output (Phase 1):** Write the gap report to `analysis/doc-map-audit.md` with the metadata header
below. This file is git-ignored; it is a worklist, not a committed artifact.

```markdown
# Doc Map Audit

**Generated:** [YYYY-MM-DD HH:MM:SS UTC]
**Branch:** [current branch name]
**HEAD Commit:** [full commit hash]
**Repository:** [repository name/path]

---
```

The report body must contain: the ranked orphaned-doc table, the scheme-violation list, and a short
"recommended cadence" call based on how many gaps exist and how concentrated they are (including
"recommend no map" when the repo does not warrant one).

## Phase 2 — Populate (choose a cadence; proposes diffs only)

Populating means creating or editing the doc map. This is file authoring: **propose it as a
reviewable diff and let the user commit.** Never auto-commit generated maps (per `commit-workflow`
steering). Every map written must obey the skill's one-hop / flat / high-signal constraints, and the
primary map must be an inline `## Document Map` section in `AGENTS.md` — never a separate referenced
file.

Pick the cadence with the user — do not assume:

### Bounded hybrid (recommended default)

Do Phase 1 completely (cheap, gives the whole picture), then quick-populate ONLY:

- the `## Document Map` section of `AGENTS.md` (or, where the fallback tier is used, the root
  `README.md`), and
- one level of high-traffic subdirectory READMEs from the top of the ranked list.

Leave the long tail to the opportunistic path below. This deliberately honors the **flat, not deep**
constraint — it does not carpet every nested directory with index files. Present the batch as a
single diff.

### Opportunistic / just-in-time (highest quality, slowest coverage)

Do not bulk-generate. Instead, the ranked gap list from Phase 1 becomes a standing worklist:
whenever normal work touches a directory whose needed doc is on that list, add that one pointer then
(and remove it from the worklist). Pointers get written exactly for the docs that proved worth
finding, self-prioritized by real usage. Coverage grows where you actually work.

> **Why Phase 1 is mandatory even for this cadence:** a purely passive opportunistic path
> systematically misses the hardest-to-discover docs — if a doc isn't mapped, the agent may never
> navigate to it, so the gap is never recorded. The Phase-1 inventory surfaces those docs up front
> so they can be promoted deliberately rather than never found.

### Quick sweep (fastest coverage, use with care)

Generate/patch the doc map and all README maps in one ordered pass. Appropriate only for a repo with
zero existing maps that needs baseline coverage fast. Higher risk of listing low-signal docs —
enforce the high-signal cap hard, and present as one large reviewable diff for the user to prune.

## Commands to gather metadata & inventory

```bash
# Metadata
git branch --show-current
git rev-parse HEAD
basename "$(git rev-parse --show-toplevel)"
date -u +"%Y-%m-%d %H:%M:%S UTC"

# All docs (exclude vendored/build)
find . -type f \( -name "*.md" -o -name "*.rst" -o -name "*.adoc" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" \
  -not -path "*/build/*" -not -path "*/.venv/*" -not -path "*/target/*"

# The primary map: the Document Map section of AGENTS.md, if present
grep -n "## Document Map" AGENTS.md

# All READMEs and their levels (the fallback map tier)
find . -type f -name "README.md" -not -path "*/node_modules/*" -not -path "*/.git/*"

# Change frequency for a doc (high count = high traffic, higher rank)
git rev-list --count HEAD -- <path/to/doc.md>
```

## Update strategy

If `analysis/doc-map-audit.md` already exists:

1. Read it and its `**HEAD Commit:**` line.
1. If the commit matches current HEAD, the audit is current — ask whether to force a refresh.
1. Otherwise re-run Phase 1, preserving any "opportunistic worklist" entries not yet populated, and
   refresh the metadata header.

## Notes

- Phase 1 is always safe (read-only). Phase 2 authors files — propose diffs, user commits.
- The authoring rules live in the `doc-map` skill; this prompt does not duplicate them.
- Chainable: run standalone via `ai-use doc-map-audit`, or as a follow-on to
  `documentation-analysis`.
