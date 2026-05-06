# Git Configuration

A comprehensive Git configuration system with context-aware settings, enhanced diff visualization,
and automated workflow hooks.

## Philosophy

- **Context-aware**: Different configurations for personal, work, and platform-specific contexts
- **Enhanced visualization**: Delta integration for superior diff and merge conflict display
- **Automated quality**: Git hooks for testing and repository maintenance
- **Conventional commits**: Structured commit message templates and AI-assisted commit generation
- **Security-first**: SSH signing, fsck validation, and credential management

## Directory Structure

```text
etc/git/
├── config                 # Main Git configuration with aliases and core settings
├── config-macos          # macOS-specific settings (credential helper)
├── config-linux          # Linux-specific settings
├── config-uniteus        # Work-specific configuration (email, signing key, repos)
├── commit-template       # Conventional commit message template
├── ignore                # Global gitignore patterns
└── hooks/                # Git hooks (referenced from config, Git 2.54+)
    ├── post-checkout     # Repository setup after clone/checkout
    └── pre-push          # Quality checks before push (tests, linting)
```

## Maintenance

### Sorting Configuration

The `scripts/sort-git-config.sh` script organizes the main config file into logical section groups:

```bash
# Sort the config file
~/dotfiles/scripts/sort-git-config.sh

# Or specify a different config
~/dotfiles/scripts/sort-git-config.sh path/to/config
```

**What it does:**

- Organizes sections into logical groups (Identity, Workflow, Display, etc.)
- Merges duplicate sections automatically
- Preserves all settings and comments
- Adds unknown sections under "Other" group

**Adding new sections:**

Edit `scripts/sort-git-config.sh` and add the section name to `SECTION_ORDER` array in the
appropriate group. Unknown sections are automatically preserved at the end.

## Architecture Overview

### Configuration Hierarchy

The main `config` file includes context-specific configurations using `includeIf` directives:

- **Platform detection**: Automatically loads macOS or Linux settings based on directory paths
- **Work context**: Loads work-specific settings for projects in `$PROJECTS_DIR/unite-us/`
- **Cascading settings**: Work and platform configs override base configuration as needed

### Core Features

- **Enhanced diff visualization**: Delta integration with Nord color scheme and side-by-side view
- **Comprehensive aliases**: Productivity shortcuts for common workflows and AI-assisted operations
- **Security configuration**: SSH signing, credential helpers, credential-in-URL warnings, and fsck
  validation
- **Performance optimization**: Commit graphs, pruning, and maintenance settings
- **Config-based hooks**: Pre-push testing and post-checkout setup defined in config (Git 2.54+),
  applying globally without template directories

### Key Conventions

- **Conventional commits**: Template-guided commit messages with type/scope/subject format
- **Fast-forward only**: Merge and pull strategies that maintain linear history
- **Auto-stash rebasing**: Seamless rebase operations with automatic stash management
- **SSH over HTTPS**: Automatic URL rewriting for GitHub operations

### Git Notes

Notes are automatically fetched and pushed with every `git fetch`/`git push` via refspecs in
`[remote "origin"]`. The `cat_sort_uniq` merge strategy ensures concurrent annotations merge
cleanly.

**Transport:**

- `fetch = +refs/notes/*:refs/notes/*` — pulls all note namespaces on fetch/pull
- `push = refs/notes/*` — pushes all note namespaces on push
- `notes.mergeStrategy = cat_sort_uniq` — concatenate, sort, deduplicate on merge conflicts

**Display:**

- `notes.displayRef = refs/notes/*` — shows all namespaces in `git log`
- `notes.rewriteRef = refs/notes/*` — preserves notes across rebase/amend
- The `lg` alias includes `--show-notes=*`

**Namespace conventions:**

| Namespace | Purpose                             | Format                  | Written by         |
| --------- | ----------------------------------- | ----------------------- | ------------------ |
| `commits` | Default — general annotations       | Plain text              | Human              |
| `review`  | Code review: approvals + discussion | Plain text (structured) | Archival script    |
| `ci`      | CI/CD build and test results        | JSON                    | CI pipeline script |
| `deploys` | Deployment records                  | JSON                    | Deploy script      |

#### `commits` (default)

Ad-hoc annotations for any purpose. Use when no specific namespace applies.

- **What:** Free-form text — corrections, cross-references, after-the-fact context

- **When:** Manually, whenever you want to annotate a commit after the fact

- **Who:** Human via `git note` alias

- **Example:**

  ```text
  This approach was later superseded by commit a1b2c3d.
  See also: https://github.com/org/repo/issues/42
  ```

#### `review`

Archived code review data: who approved, when it merged, and the full discussion thread. Provides
forge-independent history of the review process. Attached to the merge commit.

- **What:** Structured header (approvals, PR URL, merge timestamp) followed by inline code comments

- **Format:** Plain text with grep-friendly headers

- **When:** On merge, via archival script

- **Who:** Automated script (pulls from GitHub/platform API)

- **Example:**

  ```text
  PR: #571
  URL: https://github.com/org/repo/pull/571
  Merged-by: austin-mcconnell
  Merged-at: 2026-05-04T14:33:39Z
  Approved-by: brian-brazil (2026-04-30)
  Approved-by: christopher-sansone (2026-05-01)

  ---
  brian-brazil on app/fhir/models.py:null (2026-04-23)

  +        from app.enum import PerformerLookupStatus

  > This feels like it should be moved to the header since it is used in multiple places.

  ---
  austin-mcconnell on app/fhir/models.py:null (2026-04-27)

  +        from app.enum import PerformerLookupStatus

  > Good catch. Fixed
  ```

#### `ci`

CI/CD pipeline results. Opt-in per repo — only repos with a CI notes script write these. Attached to
the commit SHA that was tested.

- **What:** Build status, test results, coverage, duration

- **Format:** JSON (one object per note, parseable with `jq`)

- **When:** After CI pipeline completes (success or failure)

- **Who:** CI pipeline script (e.g., GitHub Actions step)

- **Schema:**

  ```json
  {
    "pipeline": "tests",
    "status": "passed",
    "duration_s": 142,
    "coverage": 87.5,
    "failures": [],
    "url": "https://github.com/org/repo/actions/runs/123",
    "timestamp": "2026-05-06T14:30:00Z"
  }
  ```

- **On failure**, `failures` contains the failing test names:

  ```json
  {
    "pipeline": "tests",
    "status": "failed",
    "duration_s": 98,
    "failures": ["test_user_login_expired_token", "test_api_rate_limit"],
    "url": "https://github.com/org/repo/actions/runs/124",
    "timestamp": "2026-05-06T15:00:00Z"
  }
  ```

#### `deploys`

Deployment records. Attached to the commit SHA that was deployed.

- **What:** Which environment, when, and by whom/what

- **Format:** JSON (one object per note, parseable with `jq`)

- **When:** After successful deployment

- **Who:** Deploy script or CI deploy step

- **Schema:**

  ```json
  {
    "environment": "production",
    "timestamp": "2026-05-06T16:00:00Z",
    "triggered_by": "github-actions",
    "url": "https://app.example.com",
    "rollback_sha": "a1b2c3d"
  }
  ```

**Aliases:**

- `git note` — shortcut for `git notes add`
- `git noted` — list commits that have notes attached

## Finding Specific Information

- **Aliases and shortcuts**: Check `config` file alias section for productivity commands
- **Platform settings**: Look in `config-macos` or `config-linux` for OS-specific configurations
- **Work configuration**: See `config-uniteus` for work-specific email, signing, and repositories
- **Commit guidelines**: Reference `commit-template` for conventional commit format
- **Global ignores**: Check `ignore` file for universal gitignore patterns
- **Automation**: Examine `hooks/` directory for pre-push testing and post-checkout setup
- **Delta styling**: Find diff visualization settings in the delta section of main `config`

This configuration provides a complete Git workflow system optimized for multiple contexts while
maintaining consistency and automation across different development environments.
