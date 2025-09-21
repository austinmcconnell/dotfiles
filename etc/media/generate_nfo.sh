#!/usr/bin/env bash
set -euo pipefail

[[ -f "$DOTFILES_DIR/etc/media/media-pipeline.conf" ]] && . "$DOTFILES_DIR/etc/media/media-pipeline.conf"

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
    echo "Error: TMDB_API_KEY is not set (export it or configure it)" >&2
    exit 1
fi

usage() {
    cat >&2 <<'EOF'
Usage:
  fetch_nfo_art.sh [-m TMDB_ID] [-i IMDB_ID] <video-file>

Notes:
  - Supply a single MKV path renamed in the form "Title (Year) - 1080p.mkv".
  - If multiple matches are reported, rerun with -m or -i and the same file path.
EOF
    exit 1
}

valid_year() {
    [[ "$1" =~ ^[0-9]{4}$ ]]
}

slugify() {
    local text="$1"
    text="$(printf '%s' "$text" | tr '[:upper:]' '[:lower:]')"
    text="$(printf '%s' "$text" | sed -E 's/[^a-z0-9]+//g')"
    printf '%s' "$text"
}

strip_status_suffix() {
    local name="$1"
    name="${name% --multiple-matches}"
    name="${name% --no-match}"
    printf '%s' "$name"
}

mark_status() {
    local path="$1" suffix="$2" dir base ext bare clean new_base new_path
    dir="$(dirname "$path")"
    base="$(basename "$path")"
    ext="${base##*.}"
    bare="${base%.*}"
    clean="$(strip_status_suffix "$bare")"
    new_base="${clean} --${suffix}"
    new_path="${dir}/${new_base}.${ext}"
    if [ "$path" != "$new_path" ]; then
        mv "$path" "$new_path"
    fi
    printf '%s' "$new_path"
}

canonicalise_video_name() {
    local path="$1" clean="$2" ext="$3" dir new_path
    dir="$(dirname "$path")"
    new_path="${dir}/${clean}.${ext}"
    if [ "$path" != "$new_path" ]; then
        mv "$path" "$new_path"
    fi
    printf '%s' "$new_path"
}

urlencode() {
    jq -rn --arg q "$1" '$q|@uri'
}

search_tmdb() {
    local title="$1" year="$2" encoded url
    encoded="$(urlencode "$title")"
    url="https://api.themoviedb.org/3/search/movie?api_key=${TMDB_API_KEY}&query=${encoded}"
    if [ -n "$year" ]; then
        url="${url}&year=${year}"
    fi
    curl -sS "$url"
}

write_multiple_matches_note() {
    local note_path="$1" title="$2" year="$3" response="$4" rerun_path="$5"
    {
        printf "Multiple TMDb matches for \"%s\" (%s)\n" "$title" "$year"
        printf "Re-run with: fetch_nfo_art.sh -m <TMDB_ID> '%s'\n\n" "$rerun_path"
        jq -r '.results | to_entries[] | [.key + 1, .value.id, .value.title, (.value.release_date // "unknown")] | @tsv' <<<"$response" |
            while IFS=$'\t' read -r idx tmdb_id tmdb_title tmdb_release; do
                printf "%s. TMDb ID %s - %s (%s)\n" "$idx" "$tmdb_id" "$tmdb_title" "$tmdb_release"
            done
    } >"$note_path"
}

TMDB_ID=""
IMDB_ID=""

while getopts ":m:i:h" opt; do
    case "$opt" in
    m) TMDB_ID="$OPTARG" ;;
    i) IMDB_ID="$OPTARG" ;;
    h) usage ;;
    *) usage ;;
    esac
done
shift $((OPTIND - 1))

if [ $# -ne 1 ]; then
    usage
fi

VIDEO_INPUT="$1"
if [ ! -f "$VIDEO_INPUT" ]; then
    echo "Error: video file not found: $VIDEO_INPUT" >&2
    exit 1
fi

ext="${VIDEO_INPUT##*.}"
case "${ext,,}" in
mkv) ;;
*)
    echo "Error: only MKV files are supported" >&2
    exit 1
    ;;
esac

dir="$(dirname "$VIDEO_INPUT")"
filename="$(basename "$VIDEO_INPUT")"
base_no_ext="${filename%.*}"
base_clean="$(strip_status_suffix "$base_no_ext")"

label_part="${base_clean% - *}"
resolution_part="${base_clean##* - }"
if [ "$label_part" = "$base_clean" ] || [ -z "$resolution_part" ]; then
    echo "Error: filename must contain ' - ' separator (got: $filename)" >&2
    exit 1
fi

if [[ "$label_part" =~ ^(.+)\ \(([0-9]{4}|####)\)$ ]]; then
    TITLE="${BASH_REMATCH[1]}"
    YEAR="${BASH_REMATCH[2]}"
else
    echo "Error: could not parse Title (Year) from '$label_part'" >&2
    exit 1
fi

if [ "$YEAR" = "####" ] || ! valid_year "$YEAR"; then
    echo "Warning: placeholder year detected; mark as no-match" >&2
    new_path="$(mark_status "$VIDEO_INPUT" "no-match")"
    echo "Marked file as: $(basename "$new_path")" >&2
    exit 1
fi

clean_stem="$(strip_status_suffix "$base_clean")"
title_slug="$(slugify "$TITLE")"

if [ -n "$TMDB_ID" ]; then
    resolved_tmdb="$TMDB_ID"
elif [ -n "$IMDB_ID" ]; then
    resp="$(curl -sS "https://api.themoviedb.org/3/find/${IMDB_ID}?api_key=${TMDB_API_KEY}&external_source=imdb_id")"
    resolved_tmdb="$(printf "%s" "$resp" | jq -r '.movie_results[0].id // empty')"
    if [ -z "$resolved_tmdb" ]; then
        new_path="$(mark_status "$VIDEO_INPUT" "no-match")"
        echo "Warning: IMDb lookup returned no TMDb match; marked $(basename "$new_path")" >&2
        exit 1
    fi
else
    search_resp="$(search_tmdb "$TITLE" "$YEAR")"
    exact_matches_resp="$(jq --arg year "$YEAR" --arg slug "$title_slug" '
        {results: [ .results[]
            | (.release_date // "") as $rd
            | ($rd[0:4]) as $ry
            | select($ry == $year)
            | (.title // "") as $ct
            | (.original_title // "") as $ot
            | ($ct | ascii_downcase | gsub("[^a-z0-9]"; "")) as $ct_slug
            | ($ot | ascii_downcase | gsub("[^a-z0-9]"; "")) as $ot_slug
            | select($ct_slug == $slug or $ot_slug == $slug)
        ]}
    ' <<<"$search_resp")"
    exact_count="$(jq -r '.results | length' <<<"$exact_matches_resp")"
    if [ "$exact_count" = "1" ]; then
        resolved_tmdb="$(jq -r '.results[0].id' <<<"$exact_matches_resp")"
    elif [ "$exact_count" != "0" ]; then
        note_path="${dir}/${clean_stem} --multiple-matches.txt"
        future_path="${dir}/${clean_stem} --multiple-matches.${ext}"
        write_multiple_matches_note "$note_path" "$TITLE" "$YEAR" "$exact_matches_resp" "$future_path"
        new_path="$(mark_status "$VIDEO_INPUT" "multiple-matches")"
        echo "Warning: multiple TMDb matches recorded in $(basename "$note_path"); marked $(basename "$new_path")" >&2
        exit 1
    else
        year_matches_resp="$(jq --arg year "$YEAR" '
            {results: [ .results[]
                | (.release_date // "") as $rd
                | ($rd[0:4]) as $ry
                | select($ry == $year)
            ]}
        ' <<<"$search_resp")"
        year_count="$(jq -r '.results | length' <<<"$year_matches_resp")"
        if [ "$year_count" = "1" ]; then
            resolved_tmdb="$(jq -r '.results[0].id' <<<"$year_matches_resp")"
        elif [ "$year_count" != "0" ]; then
            note_path="${dir}/${clean_stem} --multiple-matches.txt"
            future_path="${dir}/${clean_stem} --multiple-matches.${ext}"
            write_multiple_matches_note "$note_path" "$TITLE" "$YEAR" "$year_matches_resp" "$future_path"
            new_path="$(mark_status "$VIDEO_INPUT" "multiple-matches")"
            echo "Warning: multiple TMDb matches recorded in $(basename "$note_path"); marked $(basename "$new_path")" >&2
            exit 1
        else
            fallback_resp="$(search_tmdb "$TITLE" "")"
            slug_matches_resp="$(jq --arg slug "$title_slug" '
                {results: [ .results[]
                    | (.title // "") as $ct
                    | (.original_title // "") as $ot
                    | ($ct | ascii_downcase | gsub("[^a-z0-9]"; "")) as $ct_slug
                    | ($ot | ascii_downcase | gsub("[^a-z0-9]"; "")) as $ot_slug
                    | select($ct_slug == $slug or $ot_slug == $slug)
                ]}
            ' <<<"$fallback_resp")"
            slug_count="$(jq -r '.results | length' <<<"$slug_matches_resp")"
            if [ "$slug_count" = "1" ]; then
                resolved_tmdb="$(jq -r '.results[0].id' <<<"$slug_matches_resp")"
            elif [ "$slug_count" != "0" ]; then
                note_path="${dir}/${clean_stem} --multiple-matches.txt"
                future_path="${dir}/${clean_stem} --multiple-matches.${ext}"
                write_multiple_matches_note "$note_path" "$TITLE" "$YEAR" "$slug_matches_resp" "$future_path"
                new_path="$(mark_status "$VIDEO_INPUT" "multiple-matches")"
                echo "Warning: multiple TMDb matches recorded in $(basename "$note_path"); marked $(basename "$new_path")" >&2
                exit 1
            else
                new_path="$(mark_status "$VIDEO_INPUT" "no-match")"
                echo "Warning: no TMDb matches for '$TITLE' ($YEAR); marked $(basename "$new_path")" >&2
                exit 1
            fi
        fi
    fi
fi

TMDB_ID="$resolved_tmdb"

rm -f "${dir}/${clean_stem} --multiple-matches.txt"
rm -f "${dir}/${clean_stem} --no-match.txt"

VIDEO_INPUT="$(canonicalise_video_name "$VIDEO_INPUT" "$clean_stem" "$ext")"
target_path="${dir}/${clean_stem}.${ext}"
if [ "$VIDEO_INPUT" != "$target_path" ]; then
    mv "$VIDEO_INPUT" "$target_path"
fi

nfo_path="${dir}/${clean_stem}.nfo"
{
    echo "<movie>"
    echo "  <tmdbid>${TMDB_ID}</tmdbid>"
    echo "</movie>"
} >"$nfo_path"

echo "[fetch_nfo_art] TMDb ${TMDB_ID} → $(basename "$target_path")"
echo "[fetch_nfo_art] Wrote $(basename "$nfo_path")"
