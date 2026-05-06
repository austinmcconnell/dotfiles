#!/bin/bash
set -euo pipefail

# Hook script for reference-transaction event.
# Extracts author info from new commits on remote ref updates and adds to
# the username map. Two paths:
#   - Noreply emails: extract id+login+name directly (zero API calls)
#   - Corporate emails: batch GraphQL lookup for unknown logins (one API call)
#
# Heavy work (API calls) runs in background to avoid slowing fetch/pull.

[[ "${1:-}" == "committed" ]] || exit 0

MAP_FILE=".git/info/username-map"
NOREPLY_PATTERN='^([0-9]+)\+([^@]+)@users\.noreply\.github\.com$'

# Collect old..new ranges for remote ref updates only
ranges=()
while read -r old new ref; do
    case "$ref" in
    refs/remotes/*)
        if [[ "$old" == "0000000000000000000000000000000000000000" ]]; then
            ranges+=("$new")
        else
            ranges+=("${old}..${new}")
        fi
        ;;
    esac
done

[[ ${#ranges[@]} -gt 0 ]] || exit 0

mkdir -p .git/info
touch "$MAP_FILE"

sort_map() {
    sort -t= -k1,1n -o "$MAP_FILE" "$MAP_FILE"
}

# Extract unique author email+name pairs from new commits
declare -A seen_logins
new_noreply=()
unknown_names=()

while IFS=$'\t' read -r email name; do
    if [[ "$email" =~ $NOREPLY_PATTERN ]]; then
        id="${BASH_REMATCH[1]}"
        login="${BASH_REMATCH[2]}"
        [[ -n "${seen_logins[$login]:-}" ]] && continue
        seen_logins[$login]=1
        grep -q "=${login}=" "$MAP_FILE" && continue
        new_noreply+=("${id}=${login}=${name}")
    else
        [[ -n "${seen_logins[$email]:-}" ]] && continue
        seen_logins[$email]=1
        grep -qF "=${name}" "$MAP_FILE" && continue
        unknown_names+=("$name")
    fi
done < <(git log --format='%ae%x09%an' "${ranges[@]}" 2>/dev/null | sort -u)

# Write noreply entries immediately (free — no API)
for entry in "${new_noreply[@]:-}"; do
    [[ -n "$entry" ]] && echo "$entry" >>"$MAP_FILE"
done
[[ ${#new_noreply[@]} -gt 0 ]] && sort_map

# Background: resolve corporate emails via GitHub API
if [[ ${#unknown_names[@]} -gt 0 ]] && command -v gh &>/dev/null; then
    (
        declare -A name_to_login
        while IFS=$'\t' read -r login name; do
            [[ -n "$login" && -n "$name" ]] || continue
            name_to_login[$name]="$login"
        done < <(gh pr list --state merged --limit 100 --json author \
            --jq '.[] | "\(.author.login)\t\(.author.name)"' 2>/dev/null || true)

        logins_to_fetch=()
        for name in "${unknown_names[@]}"; do
            login="${name_to_login[$name]:-}"
            [[ -n "$login" ]] || continue
            grep -q "=${login}=" "$MAP_FILE" && continue
            logins_to_fetch+=("$login")
        done

        [[ ${#logins_to_fetch[@]} -gt 0 ]] || exit 0

        query="{"
        for i in "${!logins_to_fetch[@]}"; do
            query+=" u${i}: user(login: \"${logins_to_fetch[$i]}\") { login databaseId name }"
        done
        query+=" }"

        while IFS=$'\t' read -r login id name; do
            [[ -n "$login" && -n "$id" ]] || continue
            [[ "$name" == "null" ]] && name="$login"
            echo "${id}=${login}=${name}" >>"$MAP_FILE"
        done < <(gh api graphql -f query="$query" 2>/dev/null |
            jq -r '.data | to_entries[] | select(.value != null) | "\(.value.login)\t\(.value.databaseId)\t\(.value.name)"' 2>/dev/null || true)

        sort_map
    ) &
fi
