#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") <video-file>" >&2
    exit 1
}

(($# == 1)) || usage

f="$1"
[[ -f "$f" ]] || {
    echo "File not found: $f" >&2
    exit 1
}

dir="$(dirname "$f")"
base="$(basename "$f")"
name="${base%.*}"
ext="${base##*.}"
ext_lower=""
if [[ "$name" != "$base" ]]; then
    ext_lower="${ext,,}"
fi

trim() {
    local str="$1"
    str="$(printf '%s' "$str" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    printf '%s' "$str"
}

sanitize() {
    local str="$1"
    str="${str//$'\r'/ }"
    str="${str//$'\n'/ }"
    str="${str//$'\t'/ }"
    str="${str//\//-}"
    str="${str//:/ - }"
    str="${str//\?/}"
    str="${str//\*/}"
    str="${str//\"/}"
    str="${str//</}"
    str="${str//>/}"
    str="${str//|/-}"
    str="${str//[$'\000'-$'\037']/ }"
    str="$(trim "$(printf '%s' "$str" | tr -s ' ')")"
    [[ -n "$str" ]] || str="Untitled"
    printf '%s' "$str"
}

ffprobe_tag() {
    local file="$1" key val
    command -v ffprobe >/dev/null 2>&1 || return 1
    shift
    for key in "$@"; do
        val="$(ffprobe -v error -show_entries "format_tags=$key" -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null || printf '')"
        val="$(trim "$val")"
        if [[ -z "$val" ]]; then
            val="$(ffprobe -v error -select_streams v:0 -show_entries "stream_tags=$key" -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null || printf '')"
            val="$(trim "$val")"
        fi
        if [[ -n "$val" ]]; then
            printf '%s' "$val"
            return 0
        fi
    done
    return 1
}

mediainfo_tag() {
    local file="$1" key val
    command -v mediainfo >/dev/null 2>&1 || return 1
    shift
    for key in "$@"; do
        val="$(mediainfo --Inform="General;%${key}%" "$file" 2>/dev/null || printf '')"
        val="$(trim "$val")"
        if [[ -n "$val" ]]; then
            printf '%s' "$val"
            return 0
        fi
    done
    return 1
}

extract_year() {
    local raw="$1"
    if [[ "$raw" =~ ([12][0-9]{3}) ]]; then
        printf '%s' "${BASH_REMATCH[1]}"
        return 0
    fi
    return 1
}

lookup_title() {
    local file="$1" fallback="$2" value
    if value="$(ffprobe_tag "$file" title TITLE Title)"; then
        value="$(trim "$value")"
    elif value="$(mediainfo_tag "$file" Title)"; then
        value="$(trim "$value")"
    else
        value="$fallback"
    fi
    [[ -n "$value" ]] || value="$fallback"
    printf '%s' "$value"
}

lookup_year() {
    local file="$1" value year
    if value="$(ffprobe_tag "$file" DATE date YEAR Year)"; then
        if extract_year "$value" >/dev/null; then
            year="$(extract_year "$value")"
            printf '%s' "$year"
            return 0
        fi
    fi
    if value="$(mediainfo_tag "$file" Recorded_Date Released_Date Year Date Tagged_Date Encoded_Date)"; then
        if extract_year "$value" >/dev/null; then
            year="$(extract_year "$value")"
            printf '%s' "$year"
            return 0
        fi
    fi
    return 1
}

resolution_label() {
    local file="$1" height="" field="" suffix="p" scan=""
    if command -v ffprobe >/dev/null 2>&1; then
        height="$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$file" 2>/dev/null || printf '')"
        field="$(ffprobe -v error -select_streams v:0 -show_entries stream=field_order -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null || printf '')"
        height="$(trim "$height")"
        height="${height%%.*}"
        field="$(trim "$field")"
        field="${field,,}"
        if [[ "$field" =~ ^(tt|bb|tb|bt|interlaced)$ ]]; then
            suffix="i"
        fi
    fi

    if [[ ! "$height" =~ ^[0-9]+$ ]] || ((height == 0)); then
        height=""
    fi

    if [[ -z "$height" ]] && command -v mediainfo >/dev/null 2>&1; then
        height="$(mediainfo --Inform='Video;%Height%' "$file" 2>/dev/null || printf '')"
        height="${height//[^0-9]/}"
        scan="$(mediainfo --Inform='Video;%ScanType%' "$file" 2>/dev/null || printf '')"
        scan="$(trim "$scan")"
        scan="${scan,,}"
        if [[ "$scan" =~ interlaced ]]; then
            suffix="i"
        fi
    fi

    if [[ ! "$height" =~ ^[0-9]+$ ]] || ((height == 0)); then
        echo "unknown"
        return 0
    fi

    printf '%s%s' "$height" "$suffix"
}

title_raw="$(lookup_title "$f" "$name")"
title="$(sanitize "$title_raw")"

if ! year="$(lookup_year "$f")"; then
    year="####"
fi

resolution="$(resolution_label "$f")"

if [[ -n "$ext_lower" ]]; then
    new_filename="${title} (${year}) - ${resolution}.${ext_lower}"
else
    new_filename="${title} (${year}) - ${resolution}"
fi

if [[ "$base" == "$new_filename" ]]; then
    exit 0
fi

if [[ -e "$dir/$new_filename" ]]; then
    echo "Target already exists: $dir/$new_filename" >&2
    exit 1
fi

mv -v "$f" "$dir/$new_filename"
