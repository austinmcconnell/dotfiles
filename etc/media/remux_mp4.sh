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
DIR="$(dirname "$IN")"
NAME="$(basename "$IN" .mkv)"

# Detect resolution & codec for tagging hvc1 when HEVC
get_res() {
    local in="$1"
    local h
    h="$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$in" 2>/dev/null || echo 0)"
    if [[ "$h" -ge 1000 ]]; then
        echo "1080p"
    elif [[ "$h" -ge 700 ]]; then
        echo "720p"
    elif [[ "$h" -ge 570 ]]; then
        echo "576p"
    else echo "480p"; fi
}
is_hevc() {
    ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$1" 2>/dev/null | grep -qiE '^hevc$'
}

RES="$(get_res "$IN")"
OUTDIR="${REMUXED_DIR:-/path/to/remuxed}"
mkdir -p "$OUTDIR"
OUT="${OUTDIR}/${NAME} - B-${RES} AppleTV.mp4"

# Include SRT sidecar as mov_text if it exists
SRT_BASENAME="${DIR}/${NAME}.en.srt"
MAP_SUBS=()
if [[ -f "$SRT_BASENAME" ]]; then
    MAP_SUBS=(-i "$SRT_BASENAME" -c:s mov_text -map 1:0)
else
    MAP_SUBS=(-map 0:s? -c:s mov_text)
fi

FFMPEG_OPTS=(-hide_banner -y -i "$IN"
    -map 0:v:0 -c:v copy
    -map 0:a:0 -c:a:0 ac3 -b:a:0 640k
    -map 0:a:0 -c:a:1 aac -b:a:1 160k -ac:a:1 2
    "${MAP_SUBS[@]}"
    -movflags +faststart)

if is_hevc "$IN"; then
    FFMPEG_OPTS+=(-tag:v hvc1)
fi

ffmpeg "${FFMPEG_OPTS[@]}" "$OUT" || {
    echo "Error: ffmpeg remux failed" >&2
    exit 1
}
echo "[remux_mp4] Wrote: $OUT"
