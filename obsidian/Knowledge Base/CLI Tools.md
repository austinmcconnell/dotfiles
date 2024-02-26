# CLI Tools Overview

## Modern-Unix tools

A collection of modern unix cli tool upgrades: [modern-unix](https://github.com/ibraheemdev/modern-unix)

## delta

[delta](https://github.com/dandavison/delta) is a syntax-highlighting pager for git, diff, and grep output

## fd

[fd](https://github.com/sharkdp/fd) is a simple, fast and user-friendly alternative to `find`

- It ignores hidden directories and files by default
- Ignores pattens from .gitignore by default
- Supports parallel command execution
  - Instead of showing search results, do something with them
    - `-x`/`--exec` option runs an external command for each of the search results (in parallel)
    - `-X`/`--exec-batch` option launches the external command once with all search results as arguments

### Examples

Recursively find all zip archives and unpack them

```shell
fd -e zip -x unzip
```

Find all `test_*.py` files and open them in your editor

```shell
fd -g 'test_*.py' -X vim
```

## fzf

[fzf](https://github.com/junegunn/fzf) is a general-purpose command-line fuzzy finder

- `<C-t>:` Fuzzy find all files and subdirectories of current directory, and output selection to STDOUT
- `<c-r>:` Fuzzy find through your shell history, and output the selection to STDOUT
- `<o-c>:` Fuzzy find all subdirectories of the working directory, and run “cd” with the output as argument
- When multi-select is enabled, use tab and shift-tab to select files
  - `<tab>:` select a file
  - `<shift-tab>:` unselect a file
