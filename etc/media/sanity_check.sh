#!/usr/bin/env bash
set -euo pipefail
f="$1"

have_ffprobe=0
if command -v ffprobe >/dev/null 2>&1; then have_ffprobe=1; fi

# Container
if [[ $have_ffprobe -eq 1 ]]; then
    container="$(ffprobe -v error -show_entries format=format_name -of default=nk=1:nw=1 "$f" | head -1)"
else
    container="$(mediainfo --Inform='General;%Format%' "$f" 2>/dev/null || echo unknown)"
fi

# Video codec + WxH
if [[ $have_ffprobe -eq 1 ]]; then
    read -r vcodec vwidth vheight <<<"$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name,width,height -of default=nk=1:nw=1 "$f" | xargs)"
else
    vcodec="$(mediainfo --Inform='Video;%Format%' "$f" 2>/dev/null || echo unknown)"
    vwidth="$(mediainfo --Inform='Video;%Width%' "$f" 2>/dev/null || echo ?)"
    vheight="$(mediainfo --Inform='Video;%Height%' "$f" 2>/dev/null || echo ?)"
fi

# First audio codec + channels
if [[ $have_ffprobe -eq 1 ]]; then
    read -r acodec ach a_layout <<<"$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,channels,channel_layout -of default=nk=1:nw=1 "$f" | xargs)"
else
    acodec="$(mediainfo --Inform='Audio;%Format%' "$f" 2>/dev/null || echo unknown)"
    ach="$(mediainfo --Inform='Audio;%Channel(s)%' "$f" 2>/dev/null || echo ?)"
    a_layout=""
fi

# Forced subtitles present?
forced="no"
if [[ $have_ffprobe -eq 1 ]]; then
    json="$(ffprobe -v error -show_entries stream=codec_type,disposition:stream_tags=language -of json "$f" 2>/dev/null || true)"
    if echo "$json" | tr -d '\n' | grep -q '"codec_type":"subtitle"[^}]*"forced":[[:space:]]*1'; then
        forced="yes"
    fi
else
    # Best-effort with mediainfo
    if mediainfo "$f" 2>/dev/null | grep -qi 'Text'; then
        if mediainfo "$f" 2>/dev/null | grep -qi 'Forced *: *Yes'; then forced="yes"; fi
    fi
fi

printf "File: %s\nContainer: %s\nVideo: %s %sx%s\nAudio(0): %s %s %s\nForced subs: %s\n" \
    "$f" "$container" "$vcodec" "$vwidth" "$vheight" "$acodec" "$ach" "$a_layout" "$forced"
