# Formatting Commit Detection Tool

## Goal

Identify commits that only changed formatting (whitespace, indentation, line wrapping, quote style,
trailing commas, bracket positioning) without changing semantic content, so they can be added to
`.git-blame-ignore-revs` for cleaner git blame output.

## Detection Strategy — Three-Tier Pipeline

Use all three tiers in sequence. Cheap techniques filter before expensive ones. Score each commit
with a confidence level.

### Tier 1: Commit Message Heuristics (instant, low confidence — pre-filter only)

Flag commits whose messages match known formatting patterns. Use this to reduce the candidate set
for Tier 2 — never auto-include based on message alone.

**Conventional commit patterns (lowest false positive rate):**

- `style:`, `style(scope):` — the conventional commit type for formatting
- `chore: format`, `chore: lint`, `chore: run prettier`

**Tool name patterns (very low false positive rate):**

- black, ruff format, shfmt, gofmt, goimports, clang-format, rustfmt, scalafmt, yapf, autopep8,
  isort, prettier, dprint, biome

**General patterns (higher false positive rate — flag but don't trust):**

- format, fmt, reformat, autoformat, auto-format, code style, whitespace, indent, indentation, lint
  fix

Case-insensitive matching. Tool names are high signal; generic "format" is low signal.

### Tier 2: Semantic Comparison (fast-to-moderate, medium-high confidence)

For each candidate commit from Tier 1, analyze the actual diff using multiple methods:

**Step 1 — Fast whitespace check:** Use `git diff -w --quiet --exit-code commit^..commit` (not `-b`
— `-w` catches more, including spaces inserted where none existed). Exit code 0 = whitespace-only
changes. This is the fastest content-level check — `--quiet` avoids generating diff text entirely.

**Step 2 — Language-specific semantic comparison for files that aren't pure whitespace:**

- **Python files:** Compare ASTs using
  `ast.dump(ast.parse(source), annotate_fields=True, include_attributes=False)`. The
  `include_attributes=False` is critical — without it, line numbers and column offsets are included
  and every formatting change looks semantic. On Python 3.14+, use `ast.compare()` instead
  (purpose-built, more efficient, short-circuits on first difference). Handle `SyntaxError`
  gracefully — return indeterminate rather than assuming different. Do NOT use `type_comments=True`.

- **JSON files:** Parse with `json.loads()` and compare with `==`. Python dict equality handles key
  reordering correctly — no `sort_keys` needed. For JSONC files (tsconfig.json, VS Code settings,
  dprint.jsonc), use `json-with-comments` or `json5` library to strip comments before parsing.

- **YAML files:** Parse with `ruamel.yaml` (YAML 1.2), NOT PyYAML (YAML 1.1). PyYAML has the Norway
  problem — it parses bare `NO` as `False`, so adding quotes around `NO` looks like a semantic
  change when it's actually a formatting fix. Use `safe_load_all()` for multi-document files.
  Anchors/aliases are resolved by the parser.

- **TOML files:** Parse with `tomllib.loads()` (Python 3.11+) or `tomli` (older versions) and
  compare with `==`. Strict typing eliminates ambiguity — zero edge cases.

- **XML files:** Use `xml.etree.ElementTree.canonicalize()` with `strip_text=True` (Python 3.8+,
  C14N 2.0). Normalizes attribute ordering and namespace declarations.

- **Terraform/HCL files:** Try `python-hcl2` for structural comparison. Fall back to `terraform fmt`
  comparison if the binary is available. Last resort: whitespace stripping.

- **Shell scripts:** No AST option available. Whitespace stripping is the only Tier 2 approach.
  Formatter re-application (shfmt) in Tier 3 is the path to higher confidence.

- **Markdown files:** Parse with `markdown-it-py` and compare token trees. Imperfect — whitespace is
  sometimes semantic in markdown (2+ trailing spaces = `<br>`). Acceptable for a formatting
  detection tool.

- **Other languages (JS, TS, Go, Rust, C, Java, etc.):** If difftastic is installed, use
  `difft --check-only --exit-code old_file new_file` — returns 0 for no semantic changes, 1 for
  changes. Covers 50+ languages. If difftastic is not installed, fall back to whitespace stripping.

**Step 3 — Hunk-level scoring:** For commits that aren't 100% formatting-only, parse the diff with
the `unidiff` library and calculate the percentage of hunks that are formatting-only. A commit where
100% of hunks pass is high confidence. 90%+ is worth flagging for review.

### Tier 3: Formatter Re-Application (slow, highest confidence — `--verify` flag)

For the highest confidence, extract the parent commit's version of each changed file via
`git show parent:path`, run the project's configured formatter on it, and compare the output to the
commit's version. If they match, the commit is definitively formatting-only.

**Formatter detection (in priority order):**

1. `.pre-commit-config.yaml` — richest source. The `rev` field gives exact version, `types`/`files`
   fields give file mapping, hook execution order matters for multi-formatter files.
1. `pyproject.toml` — `[tool.black]`, `[tool.ruff.format]`, `[tool.yapf]` sections
1. `.prettierrc*`, `prettier.config.*` — Prettier configuration
1. `dprint.json` / `dprint.jsonc` — plugin URLs embed version numbers
1. `rustfmt.toml` / `.rustfmt.toml`, `.editorconfig`

Maintain a known-formatter allowlist (Black, Ruff, Prettier, dprint, shfmt, gofmt, rustfmt,
terraform fmt, clang-format, isort, autopep8, YAPF) rather than executing arbitrary hooks — security
concern.

**Config at commit time:** Always extract formatter config from the commit being verified, not from
HEAD. Use `git show <commit>:pyproject.toml`, etc. If the config itself changed in the commit, use
the NEW config on the OLD code (models what the developer did: changed config, then ran formatter).

Make this an optional `--verify` flag since it's slow and requires formatter installation.

## Edge Cases to Handle

- **Import reordering (isort/ruff):** Changes the AST (imports are ordered statements) but is
  universally treated as formatting. Default to conservative (treat as semantic). Add
  `--allow-import-reorder` flag that normalizes import order before AST comparison.
- **Trailing commas:** Do NOT change the Python AST, except single-element tuples — `(1,)` is a
  tuple, `(1)` is an integer.
- **String quote changes:** `ast.dump()` stores the value, not the representation. `'hello'` and
  `"hello"` produce identical ASTs. Correctly detected as formatting-only.
- **Comments (including `# type: ignore`, `# noqa`, `# fmt: off`):** Invisible to the AST.
  Comment-only changes are classified as formatting-only. This is usually correct.
- **Docstring changes:** ARE in the AST as `Constant` nodes. Changing a docstring is flagged as
  semantic. This is correct — docstrings are runtime-accessible via `__doc__`.
- **F-strings:** AST representation changed in Python 3.12 (PEP 701). Cross-version comparison risk
  if the analyzing Python version differs from the project's Python version.
- **Line continuation style:** Backslash vs parentheses produces identical ASTs. Correctly detected.
- **Mixed commits:** A commit that reformats 47 files but fixes a typo in one. Support `--strict`
  (100% formatting-only required, default) vs `--lenient` (configurable threshold, e.g., 90%).
- **Binary files:** Skip entirely. Detect with `git diff --numstat` (shows `-` for both additions
  and deletions on binary files).

## Output

- Generate a `.git-blame-ignore-revs` file with comments showing the commit message and date for
  each entry
- Print a summary table showing each candidate commit, its date, detection method, confidence level
  (high/medium/low), and number of files changed
- Support `--dry-run` mode that shows candidates without writing the file
- Support `--since` flag to limit the search range (e.g., `--since="2020-01-01"`)
- Support `--min-confidence` flag to set the inclusion threshold

Example output format for `.git-blame-ignore-revs`:

```text
# Replacing prettier with dprint (2026-04-30)
abc123def456...

# Apply ruff formatting (2025-07-28)
789abc012def...

Implementation Notes

- Write in Python. Put in scripts/find-formatting-commits.py.
- Dependencies: ruamel.yaml (YAML 1.2 parsing), unidiff (diff hunk parsing), tomli (TOML

 for Python < 3.11). Optional: json-with-comments or json5 (JSONC support), python-hcl2
 (Terraform files).

- Use git log --no-merges --format="%H|%s" as a single call to get all commit metadata, then

 iterate — avoids spawning a process per commit for the message heuristic phase.

- Use git show commit:path to get file contents at specific commits — no checkout needed.
- Exclude merge commits (--no-merges).
- Handle binary files gracefully (skip them).
- For all semantic parsers, catch parse errors gracefully — if a file doesn't parse, skip that

 file's analysis rather than failing the whole commit.

- Use ThreadPoolExecutor(max_workers=8) for parallelizing Tier 2 analysis across commits — git

 operations are I/O-bound, 4-8 workers is the sweet spot before packfile contention.

- Cache results in SQLite keyed by commit hash (immutable, safe to cache forever).
- Note on --diff-filter=M: useful for filtering to modification-only commits, but may be too

 aggressive — a formatting commit that also adds a .prettierrc would be excluded. Use as an
 optional optimization, not a hard filter.

Test it on this repo first (~/.dotfiles), then it should be generalizable to any git repo.
```
