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
Docker harness, `make docker-test` rebuilds the `Dockerfile` image, so it tests the current tree,
and runs `dotfiles test` inside it (see the `Makefile`). Layer caching keeps a rebuild cheap when
little has changed.

## Idempotency

`make docker-idempotency` rebuilds the image and runs `scripts/check-idempotency.sh` in it. The
script runs `install.sh` twice and fails if the second run changes anything the first left behind: a
file, mode, or symlink under the home directory, the repo's git state, `/etc/shells`, or the user's
`/etc/passwd` entry. File contents appear only as hashes. It skips state that changes on every shell
start or command, such as caches, Go telemetry, and fnm's per-shell links. A run takes about 3
minutes. `make docker-idempotency CHECK_ARGS=--self-test` appends a line to `~/.zshenv` before the
final snapshot and passes only if the check catches it.

The check does not cover two paths. The container cannot clone ai-dotfiles, so its installer never
runs. The image also pre-sets the `XDG_*` variables that a fresh machine lacks.

## Time limit

`.zunit.yml` sets a 5 second limit per test. zunit kills a test that runs longer and reports an
Error, which fails the run like any other failure. The kill reaches only the test's own shell: a
child process the test started (a network call, say) keeps zunit waiting until it exits. The slowest
test takes about a second; raise `time_limit` if a slower machine trips it.

## Files

| File              | Checks                                                                                 |
| :---------------- | :------------------------------------------------------------------------------------- |
| `packages.zunit`  | Tools and default packages are installed (antidote, fd, fzf, git, fnm, npm,            |
|                   | pre-commit, python, rbenv, ruby, go, vim, ctags, and default packages)                 |
| `symlinks.zunit`  | Config symlinks resolve (git config, vimrc, zsh plugins, starship, zsh functions);     |
|                   | the zsh `conf.d` and `completions` folders hold no dangling links                      |
| `syntax.zunit`    | Every zsh config file under `etc/zsh/` parses (`zsh -n`); pre-commit skips zsh files   |
| `versions.zunit`  | Vim, Ruby and Go versions, including that ruby matches the installer's default;        |
|                   | the python default links to a uv-managed interpreter; `.python-version` pins resolve   |
| `functions.zunit` | Autoloaded zsh functions from `etc/zsh/functions/` (`calc`, `get_trunk_branch`, `git`) |
| `bin.zunit`       | `bin/` commands: `dotfiles` usage output, `is-executable`, `is-supported`              |

Adding a test: create or extend a `*.zunit` file with `@test '<name>' { ... }` blocks, using `run`
and `assert`. A `@setup` block runs before each test; `functions.zunit` uses one to put
`etc/zsh/functions` on `fpath`.

The Kubernetes environment has its own bats tests in `etc/kubernetes/test/`, run separately; see
`etc/kubernetes/README.md`.
