#!/usr/bin/env bash
set -euo pipefail

f="$1"
dir="$(dirname "$f")"
base="$(basename "$f")"
name="${base%.*}"
ext="${base##*.}"

resolution_label() {
    local in="$1" h
    if command -v ffprobe >/dev/null 2>&1; then
        h="$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$in" 2>/dev/null || echo 0)"
    elif command -v mediainfo >/dev/null 2>&1; then
        h="$(mediainfo --Inform='Video;%Height%' "$in" 2>/div/null || echo 0)"
    else
        h=0
    fi
    if [[ "$h" -ge 1000 ]]; then
        echo "1080p"
    elif [[ "$h" -ge 700 ]]; then
        echo "720p"
    elif [[ "$h" -ge 570 ]]; then
        echo "576p"
    else echo "480p"; fi
}
res="$(resolution_label "$f")"

# If already labeled A-/B-/C-, keep as-is
if [[ "$name" =~ \ -\ [ABC]-[0-9]+p\ .* ]]; then
    exit 0
fi

case "${ext,,}" in
mkv)
    new="${name} - A-${res} MKV.${ext}"
    ;;
mp4 | m4v)
    if [[ "$res" =~ ^(480p|576p|720p)$ ]]; then
        new="${name} - C-${res} iPhone.${ext}"
    else
        new="${name} - B-${res} AppleTV.${ext}"
    fi
    ;;
*)
    exit 0
    ;;
esac

if [[ "$base" != "$(basename "$new")" ]]; then
    mv -v "$f" "$dir/$(basename "$new")"
fi
