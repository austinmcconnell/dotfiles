#!/usr/bin/env bash
set -euo pipefail

# Require bash 4+ for associative arrays
if ((BASH_VERSINFO[0] < 4)); then
    echo "Error: This script requires bash 4 or higher" >&2
    exit 1
fi

# Sort git config sections into logical order
# Usage: ./sort-git-config.sh [path-to-config]

CONFIG_FILE="${1:-$HOME/.dotfiles/etc/git/config}"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found: $CONFIG_FILE" >&2
    exit 1
fi

# Define section order (sections only, spacing handled separately)
declare -a SECTION_ORDER=(
    "[user]" "[gpg]" "[commit]" "[credential]"
    "[init]" "[clone]"
    "[core]"
    "[fetch]" "[pull]"
    "[branch]" "[merge]" "[mergetool]" "[mergetool \"vimdiff\"]" "[rebase]" "[rerere]"
    "[push]"
    "[log]" "[blame]" "[column]" "[color]" "[color \"status\"]" "[tag]"
    "[diff]" "[interactive]" "[delta]" "[delta \"nord-vscode-diff-colors\"]"
    "[alias]"
    "[notes]"
    "[feature]" "[protocol]" "[index]" "[pack]" "[submodule]"
    "[maintenance]" "[gc]" "[transfer]" "[receive]"
    "[advice]" "[help]"
    "[url \"git@github.com:\"]"
    "[includeIf \"hasconfig:remote.*.url:git@github.com:unite-us-engineering/**\"]" "[includeIf \"gitdir:/Users\"]" "[includeIf \"gitdir:/home\"]"
)

# Map each section to its group name
# This allows any section in a group to trigger the group header
declare -A SECTION_TO_GROUP=(
    ["[user]"]="Identity & Signing"
    ["[gpg]"]="Identity & Signing"
    ["[commit]"]="Identity & Signing"
    ["[credential]"]="Identity & Signing"
    ["[init]"]="Repository Initialization"
    ["[clone]"]="Repository Initialization"
    ["[core]"]="Core Git Behavior"
    ["[fetch]"]="Workflow: Fetching & Pulling"
    ["[pull]"]="Workflow: Fetching & Pulling"
    ["[branch]"]="Workflow: Branching & Merging"
    ["[merge]"]="Workflow: Branching & Merging"
    ["[mergetool]"]="Workflow: Branching & Merging"
    ["[mergetool \"vimdiff\"]"]="Workflow: Branching & Merging"
    ["[rebase]"]="Workflow: Branching & Merging"
    ["[rerere]"]="Workflow: Branching & Merging"
    ["[push]"]="Workflow: Committing & Pushing"
    ["[log]"]="Display & Output"
    ["[blame]"]="Display & Output"
    ["[column]"]="Display & Output"
    ["[color]"]="Display & Output"
    ["[color \"status\"]"]="Display & Output"
    ["[tag]"]="Display & Output"
    ["[diff]"]="Diff & Delta"
    ["[interactive]"]="Diff & Delta"
    ["[delta]"]="Diff & Delta"
    ["[delta \"nord-vscode-diff-colors\"]"]="Diff & Delta"
    ["[alias]"]="Aliases"
    ["[notes]"]="Notes"
    ["[feature]"]="Performance & Optimization"
    ["[protocol]"]="Performance & Optimization"
    ["[index]"]="Performance & Optimization"
    ["[pack]"]="Performance & Optimization"
    ["[submodule]"]="Performance & Optimization"
    ["[maintenance]"]="Maintenance & Integrity"
    ["[gc]"]="Maintenance & Integrity"
    ["[transfer]"]="Maintenance & Integrity"
    ["[receive]"]="Maintenance & Integrity"
    ["[advice]"]="Advice & Help"
    ["[help]"]="Advice & Help"
    ["[url \"git@github.com:\"]"]="URL Shortcuts"
    ["[includeIf \"hasconfig:remote.*.url:git@github.com:unite-us-engineering/**\"]"]="Environment-Specific Includes"
    ["[includeIf \"gitdir:/Users\"]"]="Environment-Specific Includes"
    ["[includeIf \"gitdir:/home\"]"]="Environment-Specific Includes"
)

# Parse config and merge duplicates
declare -A sections
current_section=""
current_content=""

while IFS= read -r line; do
    if [[ "$line" =~ ^\[.*\]$ ]]; then
        # Save previous section
        if [[ -n "$current_section" ]]; then
            # Trim trailing blank lines before saving
            while [[ "$current_content" =~ $'\n'$ ]]; do
                current_content="${current_content%$'\n'}"
            done

            if [[ -n "${sections[$current_section]:-}" ]]; then
                # Merge: trim existing trailing blanks, add newline, add new content
                existing="${sections[$current_section]}"
                while [[ "$existing" =~ $'\n'$ ]]; do
                    existing="${existing%$'\n'}"
                done
                sections[$current_section]="$existing"$'\n'"$current_content"
            else
                sections[$current_section]="$current_content"
            fi
        fi
        current_section="$line"
        current_content=""
    else
        # Skip old headers/comments
        if [[ "$line" =~ ^#={10,} || "$line" =~ ^#\ [A-Z] ]]; then
            continue
        fi
        [[ -n "$current_content" ]] && current_content+=$'\n'
        current_content+="$line"
    fi
done <"$CONFIG_FILE"

# Save last section
if [[ -n "$current_section" ]]; then
    while [[ "$current_content" =~ $'\n'$ ]]; do
        current_content="${current_content%$'\n'}"
    done

    if [[ -n "${sections[$current_section]:-}" ]]; then
        existing="${sections[$current_section]}"
        while [[ "$existing" =~ $'\n'$ ]]; do
            existing="${existing%$'\n'}"
        done
        sections[$current_section]="$existing"$'\n'"$current_content"
    else
        sections[$current_section]="$current_content"
    fi
fi

# Output with proper spacing
TEMP_FILE=$(mktemp)
{
    first_section=true
    last_group=""

    # Track which sections we've output
    declare -A output_sections

    # First, output all sections in defined order
    for section in "${SECTION_ORDER[@]}"; do
        [[ -z "${sections[$section]:-}" ]] && continue

        current_group="${SECTION_TO_GROUP[$section]:-}"

        # Add group header when entering a new group
        if [[ -n "$current_group" && "$current_group" != "$last_group" ]]; then
            [[ "$first_section" == false ]] && echo ""
            echo "#=========================================="
            echo "# $current_group"
            echo "#=========================================="
            last_group="$current_group"
        fi

        echo "$section"
        echo "${sections[$section]}"
        echo ""
        output_sections[$section]=1
        first_section=false
    done

    # Then, output any remaining sections under "Other"
    has_other=false
    for section in "${!sections[@]}"; do
        if [[ -z "${output_sections[$section]:-}" ]]; then
            if [[ "$has_other" == false ]]; then
                [[ "$first_section" == false ]] && echo ""
                echo "#=========================================="
                echo "# Other"
                echo "#=========================================="
                has_other=true
            fi
            echo "$section"
            echo "${sections[$section]}"
            echo ""
            first_section=false
        fi
    done
} | sed '1{/^$/d;}; ${/^$/d;}' >"$TEMP_FILE"

# Replace original file
mv "$TEMP_FILE" "$CONFIG_FILE"
echo "✓ Sorted $CONFIG_FILE"
