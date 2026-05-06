#!/bin/bash
set -euo pipefail

# Build and maintain a username map for GitHub accounts.
# Maps id=login=Display Name for substitution in git notes.
#
# Modes:
#   --capture  Batch-fetch databaseId for active users not yet in the map
#   --resolve  Resolve mannequin hashes (suspended accounts) via ID match or PR heuristic
#   (default)  Run both
#
# Map file: .git/info/username-map (one line per entry: id=login=Display Name)
# Sorted by id so pre/post-suspension entries are grouped together.
#
# Usage: git-build-username-map.sh [--capture|--resolve]

source "${DOTFILES_DIR:-$HOME/.dotfiles}/install/utils.sh"

MAP_FILE=".git/info/username-map"
MANNEQUIN_PATTERN='^[0-9a-f]{20,}_'

if ! git rev-parse --git-dir &>/dev/null; then
    log_error "Not in a git repository"
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

sort_map() {
    sort -t= -k1,1n -o "$MAP_FILE" "$MAP_FILE"
}

capture() {
    print_section_header "Capturing active user IDs"

    # Collect unique logins from PR authors not already in map
    logins_to_fetch=()
    while IFS= read -r login; do
        [[ -n "$login" ]] || continue
        [[ "$login" == */* ]] && continue # Skip app accounts (e.g., app/dependabot)
        grep -q "=${login}=" "$MAP_FILE" && continue
        logins_to_fetch+=("$login")
    done < <(gh pr list --state merged --limit 200 --json author \
        --jq '.[].author.login' 2>/dev/null | sort -u)

    if [[ ${#logins_to_fetch[@]} -eq 0 ]]; then
        log_info "No new users to capture"
        return
    fi

    log_info "Fetching IDs for ${#logins_to_fetch[@]} user(s)"

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
        echo "${id}=${login}=${name}" >>"$MAP_FILE"
        echo -e "\033[32m  ✓ ${login} (${id}) → ${name}\033[0m"
        captured=$((captured + 1))
    done < <(gh api graphql -f query="$query" 2>/dev/null |
        jq -r '.data | to_entries[] | select(.value != null) | "\(.value.login)\t\(.value.databaseId)\t\(.value.name)"' 2>/dev/null || true)

    log_info "Captured $captured new user(s)"
    sort_map
}

resolve() {
    print_section_header "Resolving mannequin usernames"

    # Find mannequin logins: either not in map, or in map with hash as display name
    mannequins=()
    while IFS= read -r login; do
        [[ "$login" =~ $MANNEQUIN_PATTERN ]] || continue
        existing=$(grep "=${login}=" "$MAP_FILE" || true)
        if [[ -z "$existing" ]]; then
            mannequins+=("$login")
        elif [[ "$existing" == *"=${login}" ]]; then
            # In map but display name is still the hash — needs resolution
            mannequins+=("$login")
        fi
    done < <(gh pr list --state merged --limit 200 --json author,reviews \
        --jq '.[].author.login, .[].reviews[].author.login' 2>/dev/null | sort -u)

    if [[ ${#mannequins[@]} -eq 0 ]]; then
        log_info "No mannequin usernames to resolve"
        return
    fi

    log_info "Found ${#mannequins[@]} mannequin(s) to resolve"

    resolved=0
    for login in "${mannequins[@]}"; do
        # First: try ID-based resolution
        id=$(gh api "/users/${login}" --jq '.id' 2>/dev/null || true)
        if [[ -n "$id" ]]; then
            # Check if this ID already has a resolved name in the map
            existing=$(grep "^${id}=" "$MAP_FILE" | grep -v "=${login}$" | head -1 || true)
            if [[ -n "$existing" ]]; then
                name=$(echo "$existing" | cut -d= -f3-)
                # Remove old unresolved entry and add resolved one
                grep -v "=${login}=" "$MAP_FILE" >"${MAP_FILE}.tmp" && mv "${MAP_FILE}.tmp" "$MAP_FILE"
                echo "${id}=${login}=${name}" >>"$MAP_FILE"
                echo -e "\033[32m  ✓ ${login} → ${name} (matched by ID ${id})\033[0m"
                resolved=$((resolved + 1))
                continue
            fi
        fi

        # Fallback: find a PR authored by this mannequin, get name from commits
        pr_number=$(gh pr list --state merged --author "$login" --limit 1 \
            --json number --jq '.[0].number // empty' 2>/dev/null || true)

        if [[ -z "$pr_number" ]]; then
            echo -e "\033[33m  ⚠ ${login} — no authored PRs found, skipping\033[0m"
            continue
        fi

        real_name=$(gh pr view "$pr_number" --json commits \
            --jq '.commits[].authors[] | "\(.name)"' 2>/dev/null |
            sort -u | head -1 || true)

        if [[ -z "$real_name" ]]; then
            echo -e "\033[33m  ⚠ ${login} — could not resolve name from PR #${pr_number}\033[0m"
            continue
        fi

        # Remove old unresolved entry if present
        grep -v "=${login}=${login}$" "$MAP_FILE" >"${MAP_FILE}.tmp" && mv "${MAP_FILE}.tmp" "$MAP_FILE"
        echo "${id:-?}=${login}=${real_name}" >>"$MAP_FILE"
        echo -e "\033[32m  ✓ ${login} → ${real_name} (from PR #${pr_number})\033[0m"
        resolved=$((resolved + 1))
    done

    log_info "Resolved $resolved mannequin(s)"
    sort_map
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
