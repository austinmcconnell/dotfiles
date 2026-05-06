#!/bin/bash
set -euo pipefail

# Backfill review notes for merged PRs in the current repo.
# Iterates oldest-first, skipping PRs that already have notes.
#
# Usage: git-backfill-reviews.sh [--limit N]

LIMIT=50
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE_SCRIPT="${SCRIPT_DIR}/git-archive-review.sh"

while [[ $# -gt 0 ]]; do
    case "$1" in
    --limit)
        LIMIT="$2"
        shift 2
        ;;
    *)
        echo "Usage: git-backfill-reviews.sh [--limit N]" >&2
        exit 1
        ;;
    esac
done

if [[ ! -x "$ARCHIVE_SCRIPT" ]]; then
    echo "Error: git-archive-review.sh not found at $ARCHIVE_SCRIPT" >&2
    exit 1
fi

echo "Fetching $LIMIT most recent merged PRs..."

archived=0
skipped=0

while read -r pr; do
    if "$ARCHIVE_SCRIPT" "$pr" 2>/dev/null; then
        archived=$((archived + 1))
    else
        # Exit code 1 from archive script means already exists or not merged
        skipped=$((skipped + 1))
    fi
done < <(gh pr list --state merged --limit "$LIMIT" --json number \
    --jq '.[].number')

echo ""
echo "Done: $archived archived, $skipped skipped"
