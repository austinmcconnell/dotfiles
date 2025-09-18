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
OUT="${TRANSCODED_DIR:-/path/to/transcoded}/${BASENAME} - iPhone-720p.mp4"

mkdir -p "${TRANSCODED_DIR:-/path/to/transcoded}"

ffmpeg -hide_banner -y -i "$IN" \
    -map 0:v:0 -vf "scale=-2:720" -c:v libx265 -preset slow -crf 24 \
    -map 0:a:0 -c:a aac -b:a 128k -ac 2 \
    -movflags +faststart \
    "$OUT" || {
    echo "Error: ffmpeg encoding failed" >&2
    exit 1
}

echo "[mobile_encode] Wrote: $OUT"
