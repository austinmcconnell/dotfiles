# Pre-commit Checks Summary

This document summarizes the pre-commit hooks that affect markdown documents and shell scripts in this repository.

## Markdown File Checks

### markdownlint-fix

- **Tool**: `markdownlint-cli` (v0.41.0)
- **Purpose**: Lints and auto-fixes markdown files
- **Config File**: `.markdownlint.json`
- **Settings**:
  - **MD007** (Unordered list indentation): 2 spaces
  - **MD013** (Line length): 100 characters max
    - Excludes code blocks and tables from length check
  - **MD024** (Multiple headings with same content): Only check siblings (allows same heading in different sections)

### trailing-whitespace

- **Tool**: `pre-commit-hooks` built-in
- **Purpose**: Removes trailing whitespace from all files
- **Applies to**: All text files including markdown

### end-of-file-fixer

- **Tool**: `pre-commit-hooks` built-in
- **Purpose**: Ensures files end with a newline
- **Excludes**: `obsidian/` and `etc/amazon-q/` directories
- **Applies to**: All text files including markdown

## Shell Script Checks

### shellcheck

- **Tool**: ShellCheck (system-installed)
- **Purpose**: Static analysis for shell scripts
- **File Types**: Shell scripts (excludes zsh)
- **Settings**: Uses default ShellCheck rules (no custom config)

### shfmt

- **Tool**: `shfmt` v3.2.2 (Go-based shell formatter)
- **Purpose**: Formats shell scripts
- **File Types**: Shell scripts (excludes zsh)
- **Settings**:
  - `-w`: Write result to file instead of stdout
  - `-i 4`: Use 4 spaces for indentation

### bashate

- **Tool**: `bashate` v2.1.0 (OpenStack shell linter)
- **Purpose**: Style checking for bash scripts
- **File Types**: Shell scripts (excludes zsh)
- **Settings**:
  - `--max-line-length 100`: Maximum 100 characters per line
  - `--ignore E004,E006,E040,E044`: Ignore specific error codes:
    - E004: Line too long (>79 chars) - overridden by max-line-length
    - E006: Line too long (>100 chars) - handled by max-line-length setting
    - E040: Syntax error (often false positive)
    - E044: Use of `$[` is deprecated in favor of `$((` (legacy compatibility)

### double-quote-string-fixer

- **Tool**: `pre-commit-hooks` built-in
- **Purpose**: Replaces single quotes with double quotes in shell scripts
- **Applies to**: All files (affects shell scripts)

### check-executables-have-shebangs

- **Tool**: `pre-commit-hooks` built-in
- **Purpose**: Ensures executable files have proper shebang lines
- **Applies to**: Executable files (including shell scripts)
