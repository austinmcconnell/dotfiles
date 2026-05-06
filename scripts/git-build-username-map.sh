#!/bin/bash
set -euo pipefail

# Build and maintain a username map for GitHub accounts.
# Maps login=id=Display Name for substitution in git notes.
#
# Modes:
#   --capture  Batch-fetch databaseId for active users not yet in the map
#   --resolve  Resolve mannequin hashes (suspended accounts) via ID match or PR heuristic
#   (default)  Run both
#
# Map file: .git/info/username-map (one line per entry: login=id=Display Name)
#
# Usage: git-build-username-map.sh [--capture|--resolve]

MAP_FILE=".git/info/username-map"
MANNEQUIN_PATTERN='^[0-9a-f]{20,}_'

if ! git rev-parse --git-dir &>/dev/null; then
    echo "Error: not in a git repository" >&2
    exit 1
fi

mkdir -p .git/info
touch "$MAP_FILE"

mode="${1:-both}"
case "$mode" in
--capture) mode="capture" ;;
--resolve) mode="resolve" ;;
both) ;;
*)
    echo "Usage: git-build-username-map.sh [--capture|--resolve]" >&2
    exit 1
    ;;
esac

capture() {
    echo "Capturing active user IDs..."

    # Collect unique logins from PR authors not already in map
    logins_to_fetch=()
    while IFS= read -r login; do
        [[ -n "$login" ]] || continue
        [[ "$login" == */* ]] && continue # Skip app accounts (e.g., app/dependabot)
        grep -q "^${login}=" "$MAP_FILE" && continue
        logins_to_fetch+=("$login")
    done < <(gh pr list --state merged --limit 200 --json author \
        --jq '.[].author.login' 2>/dev/null | sort -u)

    if [[ ${#logins_to_fetch[@]} -eq 0 ]]; then
        echo "No new users to capture."
        return
    fi

    echo "Fetching IDs for ${#logins_to_fetch[@]} user(s)..."

    # Batch GraphQL query
    query="{"
    for i in "${!logins_to_fetch[@]}"; do
        query+=" u${i}: user(login: \"${logins_to_fetch[$i]}\") { login databaseId name }"
    done
    query+=" }"

    captured=0
    while IFS=$'\t' read -r login id name; do
        [[ -n "$login" && -n "$id" ]] || continue
        [[ "$name" == "null" ]] && name="$login"
        echo "${login}=${id}=${name}" >>"$MAP_FILE"
        echo "  ✓ ${login} (${id}) → ${name}"
        captured=$((captured + 1))
    done < <(gh api graphql -f query="$query" 2>/dev/null |
        jq -r '.data | to_entries[] | select(.value != null) | "\(.value.login)\t\(.value.databaseId)\t\(.value.name)"' 2>/dev/null || true)

    echo "Captured $captured new user(s)."
}

resolve() {
    echo "Resolving mannequin usernames..."

    # Find mannequin logins from PR authors/reviewers not yet in map
    mannequins=()
    while IFS= read -r login; do
        if [[ "$login" =~ $MANNEQUIN_PATTERN ]] && ! grep -q "^${login}=" "$MAP_FILE"; then
            mannequins+=("$login")
        fi
    done < <(gh pr list --state merged --limit 200 --json author,reviews \
        --jq '.[].author.login, .[].reviews[].author.login' 2>/dev/null | sort -u)

    if [[ ${#mannequins[@]} -eq 0 ]]; then
        echo "No new mannequin usernames found."
        return
    fi

    echo "Found ${#mannequins[@]} unmapped mannequin(s)."

    resolved=0
    for login in "${mannequins[@]}"; do
        # First: try ID-based resolution
        id=$(gh api "/users/${login}" --jq '.id' 2>/dev/null || true)
        if [[ -n "$id" ]]; then
            # Check if this ID already exists in the map
            existing=$(grep "=${id}=" "$MAP_FILE" | head -1 || true)
            if [[ -n "$existing" ]]; then
                name="${existing##*=}"
                echo "${login}=${id}=${name}" >>"$MAP_FILE"
                echo "  ✓ ${login} → ${name} (matched by ID ${id})"
                resolved=$((resolved + 1))
                continue
            fi
        fi

        # Fallback: find a PR authored by this mannequin, get name from commits
        pr_number=$(gh pr list --state merged --author "$login" --limit 1 \
            --json number --jq '.[0].number // empty' 2>/dev/null || true)

        if [[ -z "$pr_number" ]]; then
            echo "  ✗ ${login} — no authored PRs found, skipping"
            continue
        fi

        real_name=$(gh pr view "$pr_number" --json commits \
            --jq '.commits[].authors[] | "\(.name)"' 2>/dev/null |
            sort -u | head -1 || true)

        if [[ -z "$real_name" ]]; then
            echo "  ✗ ${login} — could not resolve name from PR #${pr_number}"
            continue
        fi

        echo "${login}=${id:-?}=${real_name}" >>"$MAP_FILE"
        echo "  ✓ ${login} → ${real_name} (from PR #${pr_number})"
        resolved=$((resolved + 1))
    done

    echo "Resolved $resolved mannequin(s)."
}

case "$mode" in
capture) capture ;;
resolve) resolve ;;
both)
    capture
    echo ""
    resolve
    ;;
esac
