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
    echo "Usage: $0 <input.mkv>" >&2
    exit 1
fi

IN="$1"
if [ ! -f "$IN" ]; then
    echo "Error: input file not found: $IN" >&2
    exit 1
fi

# Dependencies
for bin in ffmpeg ffprobe; do
    if ! command -v "$bin" >/dev/null 2>&1; then
        echo "Error: $bin is required but not found in PATH" >&2
        exit 1
    fi
done

# Helpers
vcodec() {
    ffprobe -v error -select_streams v:0 -show_entries stream=codec_name \
        -of csv=p=0 "$1" 2>/dev/null || echo "unknown"
}

resolution_label() {
    local in="$1" h
    h="$(ffprobe -v error -select_streams v:0 -show_entries stream=height \
        -of csv=p=0 "$in" 2>/dev/null || echo 0)"
    if [ "$h" -ge 1000 ]; then
        echo "1080p"
    elif [ "$h" -ge 700 ]; then
        echo "720p"
    elif [ "$h" -ge 570 ]; then
        echo "576p"
    else echo "480p"; fi
}

# Compute Title (Year) prefix safely
base_no_ext="$(basename "$IN")"
base_no_ext="${base_no_ext%.*}"
if printf "%s" "$base_no_ext" | grep -Eq "\([0-9]{4}\)"; then
    PREFIX="$(printf "%s" "$base_no_ext" | sed -E 's/^(.*\([0-9]{4}\)).*$/\1/')"
else
    # Fallback: strip trailing " - LABEL" if present
    PREFIX="${base_no_ext%% - *}"
fi

RES="$(resolution_label "$IN")"
OUTDIR="${REMUXED_DIR:-/path/to/remuxed}"
mkdir -p "$OUTDIR"
OUT="${OUTDIR}/${PREFIX} - B-${RES} AppleTV.mp4"

VCODEC="$(vcodec "$IN")"
TAGV=()
[ "$VCODEC" = "hevc" ] && TAGV=(-tag:v hvc1)

# Remux: copy video; create AC-3 5.1 and AAC stereo; faststart for streaming
ffmpeg -hide_banner -y -i "$IN" \
    -map 0:v:0 -c:v copy "${TAGV[@]}" \
    -map 0:a:0 -c:a:0 ac3 -b:a:0 640k \
    -map 0:a:0 -c:a:1 aac -b:a:1 160k -ac:a:1 2 \
    -movflags +faststart \
    "$OUT"

echo "[remux_mp4] Wrote: $OUT"
