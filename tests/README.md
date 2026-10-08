# Tests

[zunit](https://zunit.xyz) tests that check an installed dotfiles environment: that tools are
installed, symlinks resolve, versions match, and a few shell functions and `bin/` commands behave.
They test the machine after `install.sh`, not the scripts in isolation.

## Running

```shell
dotfiles test        # runs `zunit tests/*.zunit` from the repo root
```

zunit treats every file in a directory it is given as a test and rejects any without a
`#!/usr/bin/env zunit` first line, so callers pass the `*.zunit` files explicitly rather than the
directory. That is what lets this README live here. `install.sh` runs the same command as its last
step when `zunit` is available, and the `pre-push` hook runs the `*.zunit` files it finds. In the
Docker harness, `make docker-test` runs `dotfiles test` inside the `Dockerfile` image (see the
`Makefile`).

## Files

| File              | Checks                                                                                 |
| :---------------- | :------------------------------------------------------------------------------------- |
| `packages.zunit`  | Tools and default packages are installed (antidote, fd, fzf, git, fnm, npm,            |
|                   | pre-commit, pyenv, python, rbenv, ruby, go, vim, and default packages)                 |
| `symlinks.zunit`  | Config symlinks resolve (git config, vimrc, zsh plugins, starship, zsh functions)      |
| `versions.zunit`  | Vim, Python, Ruby and Go versions, including that python and ruby match the            |
|                   | installer's default versions                                                           |
| `functions.zunit` | Autoloaded zsh functions from `etc/zsh/functions/` (`calc`, `get_trunk_branch`, `git`) |
| `bin.zunit`       | `bin/` commands: `dotfiles` usage output, `is-executable`, `is-supported`              |

Adding a test: create or extend a `*.zunit` file with `@test '<name>' { ... }` blocks, using `run`
and `assert`. A `@setup` block runs before each test; `functions.zunit` uses one to put
`etc/zsh/functions` on `fpath`.

The Kubernetes environment has its own bats tests in `etc/kubernetes/test/`, run separately; see
`etc/kubernetes/README.md`.
