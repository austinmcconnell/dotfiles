# ALE Configuration

## Overview

ALE (Asynchronous Lint Engine) runs linters and fixers asynchronously without blocking editing.

**Configuration file:** `etc/vim/plugin/ale.vim`

## How ALE Works

- Runs linters asynchronously (doesn't block editing)
- Shows errors in sign column and status line
- Supports fixers for auto-formatting
- Per-language configuration

## Current Language Support

**Python:**

- Linters: flake8, mypy
- Fixers: black, isort

**Go:**

- Linters: gofmt, golint, go vet
- Fixers: gofmt

**Ruby:**

- Linters: rubocop
- Fixers: rubocop

**Shell:**

- Linters: shellcheck
- Fixers: shfmt

**JavaScript/TypeScript:**

- Linters: eslint
- Fixers: eslint, prettier

**Terraform:**

- Linters: tflint
- Fixers: terraform fmt

**YAML:**

- Linters: yamllint
- Fixers: prettier

**Markdown:**

- Linters: markdownlint
- Fixers: prettier

**JSON:**

- Linters: jsonlint
- Fixers: jq, prettier

## Adding Language Support

### Step 1: Install Tools

```bash
# Example: Rust
rustup component add rustfmt clippy
```

### Step 2: Configure ALE

Edit `etc/vim/plugin/ale.vim`:

```vim
" Add to linters dictionary
let g:ale_linters = {
\   'rust': ['cargo', 'clippy', 'rustc'],
\}

" Add to fixers dictionary
let g:ale_fixers = {
\   'rust': ['rustfmt'],
\}
```

### Step 3: Create Language Settings

Create `etc/vim/after/ftplugin/rust.vim`:

```vim
" Rust-specific settings
setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

" Auto-format on save
let b:ale_fix_on_save = 1
```

### Step 4: Test

```vim
:e test.rs
:ALEInfo  " Check linter status
```

## Configuring Linter Options

### Global Options

In `etc/vim/plugin/ale.vim`:

```vim
let g:ale_python_flake8_options = '--max-line-length=100'
let g:ale_sh_shellcheck_options = '-x'
let g:ale_javascript_eslint_options = '--max-warnings 0'
```

### Per-Project Options

Use project config files:

- `.flake8` - Python flake8
- `.eslintrc` - JavaScript/TypeScript
- `.rubocop.yml` - Ruby
- `.shellcheckrc` - Shell

ALE automatically detects and uses them.

## Disabling Linters

### Temporarily

```vim
:ALEDisable
:ALEEnable
```

### Permanently for a Language

In `etc/vim/plugin/ale.vim`:

```vim
let g:ale_linters = {
\   'python': [],  " Disable all Python linters
\}
```

### Per-File

Add to top of file:

```vim
" vim: ale_enabled=0
```

## ALE Commands

**Status and info:**

```vim
:ALEInfo      " Show linter status and configuration
:ALEDetail    " Show full error message
```

**Running linters/fixers:**

```vim
:ALELint      " Run linters manually
:ALEFix       " Run fixers manually
```

**Navigation:**

```vim
:ALENext      " Jump to next error
:ALEPrevious  " Jump to previous error
:ALEFirst     " Jump to first error
:ALELast      " Jump to last error
```

**Control:**

```vim
:ALEEnable    " Enable ALE
:ALEDisable   " Disable ALE
:ALEToggle    " Toggle ALE
```

## ALE Configuration Options

### Fix on Save

**Global:**

```vim
let g:ale_fix_on_save = 1
```

**Per-language (in after/ftplugin):**

```vim
let b:ale_fix_on_save = 1
```

### Linter Selection

**Explicit linters:**

```vim
let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\   'javascript': ['eslint'],
\}
```

**Disable specific linters:**

```vim
let g:ale_linters_ignore = {
\   'python': ['pylint'],
\}
```

### Sign Column

```vim
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_sign_column_always = 1
```

### Status Line

```vim
let g:ale_statusline_format = ['✘ %d', '⚠ %d', '✔ OK']
```

### Completion

```vim
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
```

## Language-Specific Configuration

### Python

```vim
let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '--max-line-length=100'
let g:ale_python_black_options = '--line-length 100'
let g:ale_python_mypy_options = '--ignore-missing-imports'
```

### JavaScript/TypeScript

```vim
let g:ale_javascript_eslint_executable = 'eslint'
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5'
let g:ale_typescript_tslint_config_path = 'tslint.json'
```

### Go

```vim
let g:ale_go_gofmt_options = '-s'
let g:ale_go_golint_options = ''
let g:ale_go_govet_options = ''
```

### Ruby

```vim
let g:ale_ruby_rubocop_executable = 'rubocop'
let g:ale_ruby_rubocop_options = '--display-cop-names'
```

### Shell

```vim
let g:ale_sh_shellcheck_options = '-x'
let g:ale_sh_shfmt_options = '-i 2 -ci'
```

## Debugging ALE

### Check Linter Status

```vim
:ALEInfo
```

Shows:

- Available linters for current filetype
- Enabled linters
- Linter executables and their paths
- Linter options
- Recent errors

### Check Linter Output

```vim
:ALEDetail
```

Shows full error message with context.

### Enable Debug Mode

```vim
let g:ale_echo_cursor = 1  " Show errors under cursor
let g:ale_virtualtext_cursor = 1  " Show errors as virtual text
```

### Check Executable

```bash
which flake8
which eslint
which rubocop
```

## Common Issues

**Linter not found:**

- Install linter: `pip install flake8`, `npm install -g eslint`
- Check PATH: `echo $PATH`
- Verify executable: `which flake8`

**Wrong linter version:**

- Check version: `flake8 --version`
- Update linter: `pip install --upgrade flake8`

**Linter not running:**

- Check `:ALEInfo` for errors
- Verify linter is enabled for filetype
- Check project config files aren't disabling it

**Fixer not working:**

- Verify fixer is installed
- Check `:ALEInfo` for fixer configuration
- Try running manually: `:ALEFix`

## Best Practices

1. **Install linters globally** - Available in all projects
2. **Use project configs** - `.flake8`, `.eslintrc`, etc.
3. **Enable fix on save** - Automatic formatting
4. **Check :ALEInfo first** - Debug linter issues
5. **Use buffer-local settings** - Per-file configuration
6. **Test linters manually** - Verify before enabling
7. **Keep linters updated** - Latest versions have bug fixes
