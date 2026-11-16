#!/bin/bash
# Runs install.sh twice and fails if the second run changes anything the first left behind.
# For the Docker test image only (`make docker-idempotency`): it installs into the home directory.
# --self-test appends a line to ~/.zshenv before the final snapshot and passes only if the check
# catches it.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
WORK_DIR="$(mktemp -d)"
SELF_TEST=0
[[ "${1:-}" == "--self-test" ]] && SELF_TEST=1

# State that changes on every shell start, go command, or test run, not because of install.sh
EXCLUDES=(
    "$HOME/.cache"
    "$HOME/.config/go/telemetry"
    "$HOME/.config/zsh/.revolver"
    "$HOME/.local/state/fnm_multishells"
    "$HOME/.vim/undodir"
    "$DOTFILES_DIR/.git"
)

# Writes a manifest of the home directory (type, mode, symlink target, sha256), the repo's git
# state, and the system files install.sh edits. File contents appear only as hashes.
snapshot() {
    local prune=() path
    for path in "${EXCLUDES[@]}"; do
        prune+=(-path "$path" -prune -o)
    done
    {
        echo "## files"
        find "$HOME" "${prune[@]}" -printf '%y %m %p -> %l\n' | sort
        echo "## hashes"
        find "$HOME" "${prune[@]}" -type f -print0 | sort --zero-terminated |
            xargs --null sha256sum
        echo "## git status"
        git -C "$DOTFILES_DIR" status --porcelain --untracked-files=all
        echo "## git diff"
        git -C "$DOTFILES_DIR" diff HEAD | sha256sum
        echo "## /etc/shells"
        cat /etc/shells
        echo "## passwd"
        grep "^$(id -un):" /etc/passwd
    } >"$1"
}

run_install() {
    echo "Running install.sh ($1)..."
    if ! "$DOTFILES_DIR/install.sh" </dev/null >"$WORK_DIR/install-$1.log" 2>&1; then
        echo "✘ install.sh failed on the $1 run; last lines of its output:"
        tail -n 30 "$WORK_DIR/install-$1.log"
        exit 1
    fi
}

report_self_test() {
    if [[ -s "$WORK_DIR/changes" ]]; then
        echo "✔ Self-test passed: the check caught the injected change"
        return 0
    fi
    echo "✘ Self-test failed: the check missed the injected change"
    return 1
}

report() {
    if [[ -s "$WORK_DIR/changes" ]]; then
        echo "✘ The second install.sh run changed state:"
        cat "$WORK_DIR/changes"
        return 1
    fi
    echo "✔ The second install.sh run changed nothing"
}

run_install first
snapshot "$WORK_DIR/after-first"
run_install second
if [[ "$SELF_TEST" -eq 1 ]]; then
    echo "# idempotency self-test" >>"$HOME/.zshenv"
fi
snapshot "$WORK_DIR/after-second"
diff "$WORK_DIR/after-first" "$WORK_DIR/after-second" >"$WORK_DIR/changes" || true

if [[ "$SELF_TEST" -eq 1 ]]; then
    report_self_test
else
    report
fi
