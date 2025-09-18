#!/usr/bin/env bash
set -euo pipefail
[[ -f "$DOTFILES_DIR/etc/media/media-pipeline.conf" ]] && . "$DOTFILES_DIR/etc/media/media-pipeline.conf"

# Input validation
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <input_file>" >&2
    exit 1
fi

IN="$1"

# Validate input file exists
if [[ ! -f "$IN" ]]; then
    echo "Error: Input file '$IN' does not exist" >&2
    exit 1
fi
# Example: mark first audio default; leave subs as-is (adjust per preference)
if command -v mkvpropedit >/dev/null; then
    mkvpropedit "$IN" --edit track:a1 --set flag-default=1 || true
fi

# Quick sanity report (non-fatal)
if command -v mediainfo >/dev/null; then
    mediainfo "$IN" | sed -n '1,60p' || true
fi
