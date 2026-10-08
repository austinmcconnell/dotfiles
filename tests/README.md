# Tests

[zunit](https://zunit.xyz) tests that check an installed dotfiles environment: that tools are
installed, symlinks resolve, versions match, and a few shell functions and `bin/` commands behave.
They test the machine after `install.sh`, not the scripts in isolation.

## Running

```shell
dotfiles test        # runs `zunit tests/` from the repo root
```

`.zunit.yml` at the repo root sets `tests/` as the test directory. `install.sh` runs `zunit` as its
last step when it is available. In the Docker harness, `make docker-test` runs `dotfiles test`
inside the `Dockerfile` image (see the `Makefile`).

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
