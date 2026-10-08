# Python Configuration

This directory contains configuration files for Python development tools. Files are symlinked to
XDG-compliant locations (primarily `$XDG_CONFIG_HOME` which defaults to `~/.config`) during
installation via `install/python.sh`. The Python environment uses pyenv for version management with
global default packages automatically installed to each Python version via the
`pyenv-default-packages` plugin.

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

## Default Packages

`default-packages` is a plain-text file (not a config) that defines packages automatically installed
to each Python version managed by pyenv via the `pyenv-default-packages` plugin. It includes
linting, formatting, and LSP tools:

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
uv
yamllint
mdformat
mdformat-gfm
mdformat-gfm-alerts
mdformat-frontmatter
mdformat-simple-breaks
```

Several of these (flake8, pylint, isort, autopep8, pydocstyle, docformatter) overlap with Ruff; see
the legacy section above.

## Environment Variables

The following environment variables are set in `etc/zsh/conf.d/python.zsh` and related files:

- `PYTHONSTARTUP`: Points to `pythonrc` for REPL startup configuration
- `PYENV_ROOT`: Version manager root at `$XDG_DATA_HOME/pyenv`
- `PIPENV_VENV_IN_PROJECT`: Enabled (pipenv creates `.venv` in project root)
- `PIPENV_VERBOSITY`: Set to -1 (silent mode)
- `AUTOENV_ASSUME_YES`: Enabled (autoenv assumes yes for activation)

## Editor Integration

- **Vim ALE**: Uses ruff (linter + fixer) and python-lsp-server (completions/navigation only); all
  linting is handled by ruff
- **Sublime Text**: Ruff LSP actions on save for formatting and import organization
- **Pre-commit**: Ruff linting and formatting hooks defined in `.pre-commit-config.yaml`
