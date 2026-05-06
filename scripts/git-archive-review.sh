#!/bin/bash
set -euo pipefail

# Archive PR review data (approvals + inline comments) as a git note.
# Attaches to the merge/squash commit under refs/notes/review.
#
# Usage: git-archive-review.sh <PR-number>

if [[ $# -ne 1 ]]; then
    echo "Usage: git-archive-review.sh <PR-number>" >&2
    exit 1
fi

PR="$1"

# Get merge commit SHA and state
pr_data=$(gh pr view "$PR" --json mergeCommit,state --jq '"\(.state)\t\(.mergeCommit.oid // "")"')
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

# Build the note: header (pra) + comments (prc)
note_content=$(gh pra "$PR")
comments=$(gh prc "$PR" || true)

if [[ -n "$comments" ]]; then
    note_content="${note_content}
${comments}"
fi

# Attach the note
echo "$note_content" | git notes --ref=review add -F - "$merge_sha"
echo "✓ Archived review for PR #$PR on $merge_sha"
