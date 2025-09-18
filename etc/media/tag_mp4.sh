#!/usr/bin/env bash
set -euo pipefail

# Config: prefer DOTFILES_DIR config, fallback to HOME
if [ -n "${DOTFILES_DIR:-}" ] && [ -f "${DOTFILES_DIR}/etc/media/media-pipeline.conf" ]; then
    # shellcheck disable=SC1090
    . "${DOTFILES_DIR}/etc/media/media-pipeline.conf"
elif [ -f "${HOME}/.video-pipeline.conf" ]; then
    # shellcheck disable=SC1090
    . "${HOME}/.video-pipeline.conf"
fi

# Usage
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input.mp4>" >&2
    exit 1
fi

IN="$1"
if [ ! -f "$IN" ]; then
    echo "Error: input file not found: $IN" >&2
    exit 1
fi

TAGGED_DIR="${TAGGED_DIR:-/path/to/tagged}"
mkdir -p "$TAGGED_DIR"
POSTER="${POSTER:-}"

if [ -n "$POSTER" ] && [ ! -f "$POSTER" ]; then
    echo "Error: poster not found: $POSTER" >&2
    exit 1
fi

# Dependencies (at least one tagger should exist)
have_subler=0
have_ap=0
command -v SublerCLI >/dev/null 2>&1 && have_subler=1
command -v AtomicParsley >/dev/null 2>&1 && have_ap=1
if [ $have_subler -eq 0 ] && [ $have_ap -eq 0 ]; then
    echo "Warning: neither SublerCLI nor AtomicParsley present; skipping tagging" >&2
fi

# Work on a temp copy, then move atomically
tmp="${IN}.tagging"
cp -f "$IN" "$tmp"

if [ $have_subler -eq 1 ]; then
    if [ -n "$POSTER" ]; then
        SublerCLI -source "$tmp" -dest "$tmp" -poster "$POSTER" -optimize
    else
        SublerCLI -source "$tmp" -dest "$tmp" -optimize
    fi
elif [ $have_ap -eq 1 ]; then
    AtomicParsley "$tmp" --overWrite
fi

dest="${TAGGED_DIR}/$(basename "$IN")"
mv -f "$tmp" "$dest"
echo "[tag_mp4] Tagged and moved to: $dest"
