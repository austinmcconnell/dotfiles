#!/usr/bin/env bash
set -euo pipefail
[[ -f "$DOTFILES_DIR/etc/media/media-pipeline.conf" ]] && . "$DOTFILES_DIR/etc/media/media-pipeline.conf"

# Input validation
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <title> <year> <source_file>" >&2
    exit 1
fi

TITLE="$1"
YEAR="$2"
SRC="$3"

# Validate source file exists
if [[ ! -f "$SRC" ]]; then
    echo "Error: Source file '$SRC' does not exist" >&2
    exit 1
fi
LIB="${FINISHED_DIR:-$HOME/movies/finished}"

DEST="${LIB}/${TITLE} (${YEAR})"
mkdir -p "$DEST"

# Move the matched file and any siblings sharing the base name
BASE="${SRC%.*}"

# Use subshell to contain nullglob setting
(
    shopt -s nullglob
    for f in "$BASE"*; do
        if [[ -f "$f" ]]; then
            mv -v "$f" "$DEST/" || {
                echo "Error: Failed to move $f" >&2
                exit 1
            }
        fi
    done
)
echo "[file_into_library] Filed into: $DEST"
