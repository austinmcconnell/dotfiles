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

| Command             | Purpose                                                                              |
| :------------------ | :----------------------------------------------------------------------------------- |
| `json`              | Pretty-print JSON through `jq` from stdin, a file, or a URL (`-c` for color)         |
| `ai-usage`          | Read-only canned reports over the local AI usage and cost SQLite store               |
| `trace-search`      | Search agent trace logs by tool, text, session, or date (`--list` to see files)      |
| `engram-hygiene`    | Report accumulated engram memory-conflict debt; also run via `dotfiles memory-check` |
| `keda-demo-enqueue` | Enqueue demo tasks into Redis for the KEDA demo (`keda-demo-enqueue [count]`)        |

For the KEDA demo, see `etc/kubernetes/README.md`. For the usage store behind `ai-usage`, see
`etc/ai/usage/README.md` in the ai-dotfiles repo.
