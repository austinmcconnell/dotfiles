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

# Requirements: curl, jq, and a TMDb API key
if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required" >&2
    exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required" >&2
    exit 1
fi

TMDB_API_KEY="${TMDB_API_KEY:-}"
if [ -z "$TMDB_API_KEY" ]; then
    echo "Error: TMDB_API_KEY is not set (export it or put it in your config)" >&2
    exit 1
fi

usage() {
    cat >&2 <<'EOF'
Usage:
  fetch_nfo_art.sh -d "<movie folder>" [-t "Title"] [-y YEAR] [-m TMDB_ID] [-i IMDB_ID]

Notes:
  -d: Destination movie folder (e.g., /media/movies/Inception (2010))
  -t/-y: Title and Year (if omitted, parsed from folder: "Title (Year)")
  -m: TMDb movie ID (skips search)
  -i: IMDb ID (e.g., tt1375666) (used to look up TMDb ID)

Env/Config:
  TMDB_API_KEY must be set (export TMDB_API_KEY=... or set in config).
EOF
    exit 1
}

DEST_DIR=""
TITLE=""
YEAR=""
TMDB_ID=""
IMDB_ID=""

while getopts ":d:t:y:m:i:" opt; do
    case "$opt" in
    d) DEST_DIR="$OPTARG" ;;
    t) TITLE="$OPTARG" ;;
    y) YEAR="$OPTARG" ;;
    m) TMDB_ID="$OPTARG" ;;
    i) IMDB_ID="$OPTARG" ;;
    *) usage ;;
    esac
done

[ -z "$DEST_DIR" ] && usage
if [ ! -d "$DEST_DIR" ]; then
    echo "Error: destination folder not found: $DEST_DIR" >&2
    exit 1
fi

# Parse Title (Year) from folder name if not provided
if [ -z "$TITLE" ] || [ -z "$YEAR" ]; then
    base="$(basename "$DEST_DIR")"
    # Expect: "Title (YYYY)"
    if printf "%s" "$base" | grep -Eq "\([0-9]{4}\)"; then
        YEAR="$(printf "%s" "$base" | sed -E 's/^.*\(([0-9]{4})\).*$/\1/')"
        TITLE="$(printf "%s" "$base" | sed -E 's/^(.*)\s\(([0-9]{4})\).*$/\1/')"
    else
        echo "Warning: could not parse Title (Year) from folder; provide -t/-y" >&2
    fi
fi

# URL-encode the title using jq
urlencode() {
    jq -rn --arg q "$1" '$q|@uri'
}

# Resolve TMDB_ID if necessary
if [ -z "$TMDB_ID" ]; then
    if [ -n "$IMDB_ID" ]; then
        resp="$(curl -sS "https://api.themoviedb.org/3/find/${IMDB_ID}?api_key=${TMDB_API_KEY}&external_source=imdb_id")"
        TMDB_ID="$(printf "%s" "$resp" | jq -r '.movie_results[0].id // empty')"
    elif [ -n "$TITLE" ] && [ -n "$YEAR" ]; then
        q="$(urlencode "$TITLE")"
        resp="$(curl -sS "https://api.themoviedb.org/3/search/movie?api_key=${TMDB_API_KEY}&query=${q}&year=${YEAR}")"
        TMDB_ID="$(printf "%s" "$resp" | jq -r '.results[0].id // empty')"
        # If year was strict, try without year on empty result
        if [ -z "$TMDB_ID" ]; then
            resp="$(curl -sS "https://api.themoviedb.org/3/search/movie?api_key=${TMDB_API_KEY}&query=${q}")"
            TMDB_ID="$(printf "%s" "$resp" | jq -r '.results[0].id // empty')"
        fi
    fi
fi

if [ -z "$TMDB_ID" ]; then
    echo "Error: could not resolve TMDb ID (check title/year or provide -m/-i)" >&2
    exit 1
fi

# Fetch details incl. external_ids
detail="$(curl -sS "https://api.themoviedb.org/3/movie/${TMDB_ID}?api_key=${TMDB_API_KEY}&append_to_response=external_ids")"

# Extract fields
title="$(printf "%s" "$detail" | jq -r '.title // empty')"
year="$(printf "%s" "$detail" | jq -r '.release_date[0:4] // empty')"
plot="$(printf "%s" "$detail" | jq -r '.overview // empty' | sed 's/\r//g')"
imdb="$(printf "%s" "$detail" | jq -r '.external_ids.imdb_id // empty')"
poster_path="$(printf "%s" "$detail" | jq -r '.poster_path // empty')"
backdrop_path="$(printf "%s" "$detail" | jq -r '.backdrop_path // empty')"

# Fallbacks
[ -z "$TITLE" ] && TITLE="$title"
[ -z "$YEAR" ] && YEAR="$year"

# Build NFO filename (prefer "Title (Year).nfo" if pattern matches folder; else movie.nfo)
nfo_name="movie.nfo"
if printf "%s" "$(basename "$DEST_DIR")" | grep -Eq "\([0-9]{4}\)"; then
    nfo_name="$(basename "$DEST_DIR").nfo"
fi

# Write minimal NFO (Kodi/Jellyfin-style)
# Use uniqueid for tmdb/imdb when available
{
    echo "<movie>"
    echo "  <title>${TITLE}</title>"
    if [ -n "$YEAR" ]; then
        echo "  <year>${YEAR}</year>"
    fi
    if [ -n "$plot" ]; then
        printf "  <plot>%s</plot>\n" "$plot"
    fi
    if [ -n "$imdb" ]; then
        echo "  <id>${imdb}</id>"
    fi
    echo "  <uniqueid type=\"tmdb\" default=\"true\">${TMDB_ID}</uniqueid>"
    if [ -n "$imdb" ]; then
        echo "  <uniqueid type=\"imdb\">${imdb}</uniqueid>"
    fi
    echo "</movie>"
} >"${DEST_DIR}/${nfo_name}"

# Download images (pick sensible sizes)
img_base="https://image.tmdb.org/t/p"
if [ -n "$poster_path" ]; then
    curl -sS -o "${DEST_DIR}/poster.jpg" "${img_base}/w500${poster_path}" || true
fi
if [ -n "$backdrop_path" ]; then
    curl -sS -o "${DEST_DIR}/backdrop.jpg" "${img_base}/w1280${backdrop_path}" || true
fi

echo "[fetch_nfo_art] Wrote ${DEST_DIR}/${nfo_name}"
[ -f "${DEST_DIR}/poster.jpg" ] && echo "[fetch_nfo_art] Downloaded poster.jpg"
[ -f "${DEST_DIR}/backdrop.jpg" ] && echo "[fetch_nfo_art] Downloaded backdrop.jpg"
