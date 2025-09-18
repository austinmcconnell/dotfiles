#!/usr/bin/env bash
set -euo pipefail
[[ -f "$DOTFILES_DIR/etc/media/media-pipeline.conf" ]] && . "$DOTFILES_DIR/etc/media/media-pipeline.conf"

# Input validation
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <input_file> [poster_file]" >&2
    exit 1
fi

IN="$1"
POSTER="${2:-${POSTER:-}}"

# Validate input file exists
if [[ ! -f "$IN" ]]; then
    echo "Error: Input file '$IN' does not exist" >&2
    exit 1
fi

# Validate poster file if provided
if [[ -n "$POSTER" && ! -f "$POSTER" ]]; then
    echo "Error: Poster file '$POSTER' does not exist" >&2
    exit 1
fi

mkdir -p "${TAGGED_DIR:-/path/to/tagged}"

# Create temp file for atomic operations
TEMP_FILE="${IN}.tmp"
cp "$IN" "$TEMP_FILE" || {
    echo "Error: Failed to create temp file" >&2
    exit 1
}

# Write tags to temp file
if command -v SublerCLI >/dev/null 2>&1; then
    if [[ -n "$POSTER" && -f "$POSTER" ]]; then
        SublerCLI -source "$TEMP_FILE" -dest "$TEMP_FILE" -poster "$POSTER" -optimize || {
            echo "Error: SublerCLI tagging failed" >&2
            rm -f "$TEMP_FILE"
            exit 1
        }
    else
        SublerCLI -source "$TEMP_FILE" -dest "$TEMP_FILE" -optimize || {
            echo "Error: SublerCLI optimization failed" >&2
            rm -f "$TEMP_FILE"
            exit 1
        }
    fi
elif command -v AtomicParsley >/dev/null 2>&1; then
    AtomicParsley "$TEMP_FILE" --overWrite || {
        echo "Error: AtomicParsley tagging failed" >&2
        rm -f "$TEMP_FILE"
        exit 1
    }
else
    echo "Warning: No tagging tool available (SublerCLI or AtomicParsley)" >&2
fi

# Move temp file to final destination
FINAL_DEST="${TAGGED_DIR:-/path/to/tagged}/$(basename "$IN")"
mv "$TEMP_FILE" "$FINAL_DEST" || {
    echo "Error: Failed to move to tagged directory" >&2
    rm -f "$TEMP_FILE"
    exit 1
}

# Remove original only after successful move
rm -f "$IN"
echo "[tag_mp4] Tagged and moved to: $FINAL_DEST"
