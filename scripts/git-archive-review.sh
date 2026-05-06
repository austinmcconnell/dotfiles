#!/bin/bash
set -euo pipefail

# Archive PR review data as git notes on the merge/squash commit.
# Header (PR link, merged-by, approved-by) → refs/notes/review
# Inline code comments → refs/notes/review-comments
#
# Usage: git-archive-review.sh <PR-number>

MAX_RETRIES=5

# Retry a command with exponential backoff (1s, 2s, 4s, 8s, 16s).
gh_retry() {
    local attempt=0
    local delay=1
    local output

    while true; do
        if output=$("$@" 2>/dev/null); then
            echo "$output"
            return 0
        fi

        attempt=$((attempt + 1))
        if [[ $attempt -ge $MAX_RETRIES ]]; then
            echo "Error: command failed after $MAX_RETRIES attempts: $*" >&2
            return 1
        fi

        echo "  Rate limited, retrying in ${delay}s (attempt $((attempt + 1))/$MAX_RETRIES)..." >&2
        sleep "$delay"
        delay=$((delay * 2))
    done
}

if [[ $# -ne 1 ]]; then
    echo "Usage: git-archive-review.sh <PR-number>" >&2
    exit 1
fi

PR="$1"

# Get merge commit SHA and state
pr_data=$(gh_retry gh pr view "$PR" --json mergeCommit,state --jq '"\(.state)\t\(.mergeCommit.oid // "")"')
state=$(echo "$pr_data" | cut -f1)
merge_sha=$(echo "$pr_data" | cut -f2)

if [[ "$state" != "MERGED" ]]; then
    echo "Error: PR #$PR is not merged (state: $state)" >&2
    exit 1
fi

if [[ -z "$merge_sha" ]]; then
    echo "Error: PR #$PR has no merge commit SHA" >&2
    exit 1
fi

# Check if note already exists
if git notes --ref=review show "$merge_sha" &>/dev/null; then
    echo "Note already exists for PR #$PR on $merge_sha. Use -f to overwrite." >&2
    exit 1
fi

# Fetch header and comments separately
header=$(gh_retry gh pra "$PR")
comments=$(gh_retry gh prc "$PR" || true)

# Add comment count to header (like Gerrit's reviewnotes)
if [[ -n "$comments" ]]; then
    comment_count=$(echo "$comments" | grep -c '^---$')
    header="${header}
Comments: ${comment_count}"
else
    header="${header}
Comments: 0"
fi

# Apply username map substitutions
MAP_FILE=".git/info/username-map"
if [[ -f "$MAP_FILE" ]]; then
    while IFS='=' read -r _id login name; do
        [[ -z "$_id" || "$_id" == \#* ]] && continue
        header="${header//$login/$name}"
        [[ -n "$comments" ]] && comments="${comments//$login/$name}"
    done <"$MAP_FILE"
fi

# Write header to refs/notes/review
echo "$header" | git notes --ref=review add -F - "$merge_sha"

# Write comments to refs/notes/review-comments (only if non-empty)
if [[ -n "$comments" ]]; then
    echo "$comments" | git notes --ref=review-comments add -F - "$merge_sha"
fi

echo "✓ Archived review for PR #$PR on $merge_sha"
