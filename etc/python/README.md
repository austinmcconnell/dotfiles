# Python Configuration

This directory contains configuration files for Python development tools. Files are symlinked to
XDG-compliant locations (primarily `$XDG_CONFIG_HOME` which defaults to `~/.config`) during
installation via `install/python.sh`. Python interpreters are managed by uv, and global developer
tools are installed as isolated `uv tool` environments from `uv-tools`.

## Project Dependency Management

For new projects, [uv](https://docs.astral.sh/uv/) is the default installer and lockfile manager:
declare dependencies in `pyproject.toml` (with `[dependency-groups]` for dev tooling), commit the
resulting `uv.lock`, and run `uv sync` to create and populate the project `.venv`. The `mkvenv`
shell helper (`etc/zsh/conf.d/venv.zsh`) follows this convention.

pip and pipenv remain supported fallbacks — `mkvenv` creates a plain `python -m venv` + `pip`
environment from `requirements.txt`, and a `pipenv` environment from a `Pipfile` — but new projects
should prefer uv.

This is a project-level convention only. Interpreters are installed with `uv python install` (see
Interpreters below).

## Interpreters

`install/python.sh` installs one uv-managed interpreter per supported minor version (3.11 through
3.15) with `uv python install -U`. The `-U` flag moves an existing install to its latest patch.

Bare `python` and `python3` link to the second-newest of these minors (3.14 today), so a new release
becomes the default only after a few months of ecosystem catch-up.

A directory with a `.python-version` file resolves bare `python` and `python3` to that version. The
hook in `etc/zsh/conf.d/python.zsh` runs on every `cd`, links the uv interpreter into
`$XDG_CACHE_HOME/zsh/python-implicit`, and prepends that directory to `PATH` only while the cwd is
pinned (or inside a pinned directory). If the pinned version is not installed, the hook prints the
`uv python install` command to run.

## Installation and Symlink Targets

| File             | Tool         | Symlink Target                           | Status   |
| :--------------- | :----------- | :--------------------------------------- | :------- |
| `ruff.toml`      | Ruff         | `$XDG_CONFIG_HOME/ruff/ruff.toml`        | ACTIVE   |
| `pip.conf`       | Pip          | `$XDG_CONFIG_HOME/pip`                   | ACTIVE   |
| `pythonrc`       | Python REPL  | `$XDG_CONFIG_HOME/python/pythonrc`       | ACTIVE   |
| `mdformat.toml`  | mdformat     | `$HOME/.mdformat.toml`                   | ACTIVE   |
| `proselint.json` | proselint    | `$XDG_CONFIG_HOME/proselint/config.json` | OPTIONAL |
| `flake8`         | flake8       | `$XDG_CONFIG_HOME`                       | LEGACY   |
| `pylintrc`       | pylint       | `$XDG_CONFIG_HOME`                       | LEGACY   |
| `yapf`           | yapf         | `$XDG_CONFIG_HOME/yapf/style`            | LEGACY   |
| `.isort.cfg`     | isort        | `$XDG_CONFIG_HOME/isort/config`          | LEGACY   |
| `autopep8`       | autopep8     | `$XDG_CONFIG_HOME/pycodestyle`           | LEGACY   |
| `mypy`           | mypy         | `$XDG_CONFIG_HOME/mypy/config`           | LEGACY   |
| `docformatter`   | docformatter | (not symlinked)                          | UNUSED   |
| `pydocstyle`     | pydocstyle   | (not symlinked)                          | UNUSED   |

## Active Tools

### Ruff (Linting & Formatting)

`ruff.toml` is the canonical linting and formatting configuration. Ruff is configured with extensive
rule coverage including pycodestyle (E, W), Pyflakes (F), isort (I), flake8-bugbear (B), pyupgrade
(UP), and pylint (PL) rules. In Vim, ALE runs `ruff` and `ruff_format` as linters and fixers. In
Sublime Text, ruff LSP actions handle formatting and import organization on save. In pre-commit,
ruff runs as both linter (`--fix`) and formatter.

### pip Configuration

`pip.conf` sets trusted hosts for PyPI and related repositories to avoid certificate warnings.

### Python REPL Startup

`pythonrc` is invoked via the `PYTHONSTARTUP` environment variable (set in
`etc/zsh/conf.d/ python.zsh`). It configures readline history to persist in
`$XDG_DATA_HOME/python/python_history` rather than in the home directory root.

### Markdown Formatting

`mdformat.toml` configures markdown formatting with 100-character line wrapping. It is symlinked to
`$HOME/.mdformat.toml` (outside XDG locations due to mdformat's filename convention) and is used by
Vim ALE, pre-commit, and Sublime Text.

### Proselint (Optional)

`proselint.json` is symlinked but not active by default in Vim ALE. It can be enabled on-demand with
the `ProseOn` command in Vim for prose-writing directories (writing, blog, essays, etc.).

## Legacy/Replaced Configurations

The following tools have been superseded by Ruff and are no longer active consumers, though their
configs are retained for reference:

- **flake8**: Ruff includes all flake8 rules (E, W, F, B, etc.)
- **pylint**: Ruff includes pylint rules (PL); see `scripts/convert-pylint-to-ruff.sh` for migration
  support
- **yapf**: Ruff formatter handles formatting
- **isort**: Ruff's isort plugin (I rules) handles import sorting
- **autopep8**: Ruff fixes pycodestyle issues
- **mypy**: Type checking config retained for reference, but not actively run by Vim ALE

The migration from these individual linters to Ruff was completed to centralize linting, reduce tool
fragmentation, and simplify maintenance. See `scripts/convert-pylint-to-ruff.sh` for a utility to
migrate pylint disable comments in codebases to ruff noqa equivalents.

## Unused Configurations

`docformatter` and `pydocstyle` are not symlinked during installation. The docstring formatting
rules are integrated into Ruff's docstring linting (D rules) via the `pydocstyle` convention setting
in `ruff.toml`.

## Global Tools

`uv-tools` is a plain-text file (not a config) that lists the global developer tools installed by
`install/python.sh` with `uv tool install`. Each line is one tool and its `uv tool install`
arguments, including any `--with` plugins. Each tool gets its own isolated environment, and its
executable is linked into `~/.local/bin`. The tools include linting, formatting, and LSP:

```text
ansible-lint
autopep8
bashate
cruft
docformatter
flake8
isort
mypy
pip-audit
pipenv
pre-commit
proselint
pydocstyle
pylint
pyupgrade
python-lsp-server[all]
ruff
yamllint
mdformat --with mdformat-gfm --with mdformat-gfm-alerts --with mdformat-frontmatter --with mdformat-simple-breaks
```

Several of these (flake8, pylint, isort, autopep8, pydocstyle, docformatter) overlap with Ruff; see
the legacy section above.

## Environment Variables

The following environment variables are set in `etc/zsh/conf.d/python.zsh` and related files:

- `PYTHONSTARTUP`: Points to `pythonrc` for REPL startup configuration
- `PIPENV_VENV_IN_PROJECT`: Enabled (pipenv creates `.venv` in project root)
- `PIPENV_VERBOSITY`: Set to -1 (silent mode)
- `AUTOENV_ASSUME_YES`: Enabled (autoenv assumes yes for activation)

## Editor Integration

- **Vim ALE**: Uses ruff (linter + fixer) and python-lsp-server (completions/navigation only); all
  linting is handled by ruff
- **Sublime Text**: Ruff LSP actions on save for formatting and import organization
- **Pre-commit**: Ruff linting and formatting hooks defined in `.pre-commit-config.yaml`
