#!/usr/bin/env bash
set -euo pipefail
[[ -f "$DOTFILES_DIR/etc/media/media-pipeline.conf" ]] && . "$DOTFILES_DIR/etc/media/media-pipeline.conf"

# Input validation
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <input_file>" >&2
    exit 1
fi

# Dependency check
command -v ffmpeg >/dev/null || {
    echo "Error: ffmpeg is required but not installed" >&2
    exit 1
}

IN="$1"

# Validate input file exists
if [[ ! -f "$IN" ]]; then
    echo "Error: Input file '$IN' does not exist" >&2
    exit 1
fi
BASENAME="$(basename "$IN")"
BASENAME="${BASENAME%.*}" # Remove any extension
OUT="${REMUXED_DIR:-/path/to/remuxed}/${BASENAME} - AppleTV.mp4"

mkdir -p "${REMUXED_DIR:-/path/to/remuxed}"

# Copy video, produce AC-3 5.1 and AAC stereo; skip subs by default (PGS not supported in MP4)
ffmpeg -hide_banner -y -i "$IN" \
    -map 0:v:0 -c:v copy \
    -map 0:a:0 -c:a:0 ac3 -b:a:0 640k \
    -map 0:a:0 -c:a:1 aac -b:a:1 160k -ac:a:1 2 \
    -movflags +faststart \
    "$OUT" || {
    echo "Error: ffmpeg remux failed" >&2
    exit 1
}

echo "[remux_mp4] Wrote: $OUT"
