# Bin

Executables for the dotfiles repo. `bin/` is on `PATH`, so these run by name. The `is-*` scripts are
small predicates used by install scripts and shell config; the rest are standalone tools.

## The `dotfiles` command

`dotfiles` is the entry point for repo maintenance: updating packages, cleaning caches, syncing
repositories, applying macOS settings, and running tests. Run `dotfiles help` for the current
subcommand list; the root `README.md` shows the same output.

### Adding a subcommand

`dotfiles` dispatches to a function named `sub_<command>` in `bin/dotfiles`. Add the function, then
add a line to `sub_help` so the command appears in `dotfiles help`:

```bash
sub_hello() {
    echo "Hello from dotfiles"
}
```

Two other lists name the public commands and are not generated from `sub_help`. Add the command to
the word list echoed by `sub_completion` in `bin/dotfiles`, and to the `commands` array in
`etc/zsh/completions/_dotfiles`, so it tab-completes.

## Platform predicates

Each exits `0` when true and `1` when false, so they work in `if` and `&&`.

| Command         | True when                                                                  |
| :-------------- | :------------------------------------------------------------------------- |
| `is-macos`      | `$OSTYPE` starts with `darwin`                                             |
| `is-debian`     | `$OSTYPE` is `linux-gnu` (any Linux, not only Debian)                      |
| `is-executable` | the named command is available on `PATH`                                   |
| `is-work`       | `$IS_WORK_COMPUTER` is `1` (`0` on a personal machine is not work)         |
| `is-supported`  | a command succeeds: `is-supported <cmd>` sets the exit code; with two more |
|                 | arguments (`<cmd> <yes> <no>`) it prints one of them instead               |

## Tools

| Command             | Purpose                                                                       |
| :------------------ | :---------------------------------------------------------------------------- |
| `json`              | Pretty-print JSON through `jq` from stdin, a file, or a URL (`-c` for color)  |
| `keda-demo-enqueue` | Enqueue demo tasks into Redis for the KEDA demo (`keda-demo-enqueue [count]`) |

For the KEDA demo, see `etc/kubernetes/README.md`. The AI commands `ai-usage`, `trace-search`, and
`engram-hygiene` live in the ai-dotfiles repo's `bin/`, which `.zprofile` puts on `PATH`.
