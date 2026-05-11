#!/bin/bash
set -euo pipefail

# Fix file creation/modification dates from EXIF metadata.
# Recursively processes image/video files, setting filesystem dates
# to match the embedded capture date.
#
# Usage:
#   fix-photo-dates.sh [directory]        # dry-run (default)
#   fix-photo-dates.sh --apply [directory] # apply changes

APPLY=false
TARGET_DIR="."

for arg in "$@"; do
    case "${arg}" in
    --apply)
        APPLY=true
        ;;
    *)
        TARGET_DIR="${arg}"
        ;;
    esac
done

# Normalize target dir (remove trailing slash for consistent relative paths)
TARGET_DIR="${TARGET_DIR%/}"

if ! command -v exiftool &>/dev/null; then
    echo "Error: exiftool not found. Install with: brew install exiftool" >&2
    exit 1
fi

if ! command -v jq &>/dev/null; then
    echo "Error: jq not found. Install with: brew install jq" >&2
    exit 1
fi

if [[ "${APPLY}" == false ]]; then
    echo -e "\033[0;33m=== DRY RUN (pass --apply to make changes) ===\033[0m"
    echo ""
fi

EXTENSIONS=("jpg" "jpeg" "png" "heic" "heif" "mov" "mp4" "m4v" "avi")

# Build exiftool extension args
EXT_ARGS=()
for ext in "${EXTENSIONS[@]}"; do
    EXT_ARGS+=("-ext" "${ext}")
done

# Convert exif date (2010:06:30 18:09:56) to human-readable (Jun 30, 2010 6:09 PM)
format_date() {
    local exif_date="$1"
    local parseable="${exif_date:0:4}-${exif_date:5:2}-${exif_date:8}"
    date -d "${parseable}" "+%b %-d, %Y %-I:%M %p" 2>/dev/null || echo "${exif_date}"
}

SKIPPED=0
UPDATED=0
ALREADY_CORRECT=0

# Process one directory at a time for progressive output
process_directory() {
    local dir="$1"

    # Batch-read metadata for this directory only (non-recursive)
    local json
    json=$(exiftool -json -DateTimeOriginal -CreateDate -FileModifyDate \
        -api QuickTimeUTC "${EXT_ARGS[@]}" "${dir}" 2>/dev/null) || return 0

    local file_count
    file_count=$(echo "${json}" | jq 'length')
    if [[ "${file_count}" -eq 0 ]]; then
        return 0
    fi

    # Display path relative to target directory
    local relative_dir="${dir#"${TARGET_DIR}"}"
    relative_dir="${relative_dir#/}"
    if [[ -z "${relative_dir}" ]]; then
        relative_dir="."
    fi

    echo ""
    echo -e "\033[1;36m📁 ${relative_dir}\033[0m"

    # Sort by filename within directory
    json=$(echo "${json}" | jq 'sort_by(.SourceFile)')

    for ((i = 0; i < file_count; i++)); do
        local file file_name original_date current_mod original_trimmed
        file=$(echo "${json}" | jq -r ".[${i}].SourceFile")
        file_name=$(basename "${file}")

        # Try DateTimeOriginal first, fall back to CreateDate
        original_date=$(echo "${json}" | jq -r ".[${i}].DateTimeOriginal // empty")
        if [[ -z "${original_date}" ]]; then
            original_date=$(echo "${json}" | jq -r ".[${i}].CreateDate // empty")
        fi

        if [[ -z "${original_date}" || "${original_date}" == "0000:00:00 00:00:00" ]]; then
            echo -e "  \033[0;33m⚠ ${file_name} — no EXIF date found\033[0m"
            SKIPPED=$((SKIPPED + 1))
            continue
        fi

        # Get current file modification date (strip timezone suffix)
        current_mod=$(echo "${json}" | jq -r ".[${i}].FileModifyDate // empty" | head -c 19)
        original_trimmed="${original_date:0:19}"

        if [[ "${current_mod}" == "${original_trimmed}" ]]; then
            echo -e "  \033[0;32m✓ ${file_name}\033[0m"
            ALREADY_CORRECT=$((ALREADY_CORRECT + 1))
            continue
        fi

        local current_pretty original_pretty
        current_pretty=$(format_date "${current_mod}")
        original_pretty=$(format_date "${original_trimmed}")

        if [[ "${APPLY}" == true ]]; then
            exiftool -overwrite_original \
                "-FileModifyDate<DateTimeOriginal" \
                "-FileCreateDate<DateTimeOriginal" \
                "${file}" >/dev/null 2>&1 ||
                exiftool -overwrite_original \
                    -api QuickTimeUTC \
                    "-FileModifyDate<CreateDate" \
                    "-FileCreateDate<CreateDate" \
                    "${file}" >/dev/null 2>&1 ||
                {
                    echo -e "  \033[0;31m✗ ${file_name} — failed\033[0m"
                    continue
                }
            echo -e "  \033[0;32m✓ ${file_name}  ${current_pretty} → ${original_pretty}\033[0m"
        else
            echo -e "  ${file_name}  \033[0;31m${current_pretty}\033[0m → \033[0;32m${original_pretty}\033[0m"
        fi
        UPDATED=$((UPDATED + 1))
    done
}

# Find all directories containing matching files, then process each
while IFS= read -r dir; do
    process_directory "${dir}"
done < <(find "${TARGET_DIR}" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
    -iname "*.heic" -o -iname "*.heif" -o -iname "*.mov" -o \
    -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.avi" \
    \) -exec dirname {} \; | sort -u)

echo ""
echo "--- Summary ---"
echo "Would fix / Fixed: ${UPDATED}"
echo "Already correct:   ${ALREADY_CORRECT}"
echo "Skipped (no date): ${SKIPPED}"
