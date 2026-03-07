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

# Define section order with comments
declare -a SECTION_ORDER=(
    "#=========================================="
    "# Identity & Signing"
    "#=========================================="
    "[user]"
    "[gpg]"
    "[commit]"
    ""
    "#=========================================="
    "# Repository Initialization"
    "#=========================================="
    "[init]"
    "[clone]"
    ""
    "#=========================================="
    "# Core Git Behavior"
    "#=========================================="
    "[core]"
    ""
    "#=========================================="
    "# Workflow: Fetching & Pulling"
    "#=========================================="
    "[fetch]"
    "[pull]"
    ""
    "#=========================================="
    "# Workflow: Branching & Merging"
    "#=========================================="
    "[branch]"
    "[merge]"
    "[mergetool]"
    "[mergetool \"vimdiff\"]"
    "[rebase]"
    "[rerere]"
    ""
    "#=========================================="
    "# Workflow: Committing & Pushing"
    "#=========================================="
    "[push]"
    ""
    "#=========================================="
    "# Display & Output"
    "#=========================================="
    "[log]"
    "[blame]"
    "[column]"
    "[color]"
    "[color \"status\"]"
    ""
    "#=========================================="
    "# Diff & Delta"
    "#=========================================="
    "[diff]"
    "[interactive]"
    "[delta]"
    "[delta \"nord-vscode-diff-colors\"]"
    ""
    "#=========================================="
    "# Aliases"
    "#=========================================="
    "[alias]"
    ""
    "#=========================================="
    "# Notes"
    "#=========================================="
    "[notes]"
    ""
    "#=========================================="
    "# Performance & Optimization"
    "#=========================================="
    "[feature]"
    "[protocol]"
    "[index]"
    "[pack]"
    "[submodule]"
    ""
    "#=========================================="
    "# Maintenance & Integrity"
    "#=========================================="
    "[maintenance]"
    "[gc]"
    "[transfer]"
    "[receive]"
    ""
    "#=========================================="
    "# Advice & Help"
    "#=========================================="
    "[advice]"
    "[help]"
    ""
    "#=========================================="
    "# URL Shortcuts"
    "#=========================================="
    "[url \"git@github.com:\"]"
    ""
    "#=========================================="
    "# Environment-Specific Includes"
    "#=========================================="
    "[includeIf \"gitdir:~/projects/unite-us/\"]"
    "[includeIf \"gitdir:/Users\"]"
    "[includeIf \"gitdir:/home\"]"
)

# Parse config file into associative array: section_name -> section_content
declare -A sections
current_section=""
current_content=""

while IFS= read -r line; do
    # Check if line is a section header
    if [[ "$line" =~ ^\[.*\]$ ]]; then
        # Save previous section if exists
        if [[ -n "$current_section" ]]; then
            sections["$current_section"]="$current_content"
        fi
        # Start new section
        current_section="$line"
        current_content=""
    else
        # Skip old section comments and delta markers
        if [[ "$line" =~ ^#.*[Ss]tart.*delta || "$line" =~ ^#.*[Ee]nd.*delta || "$line" =~ ^#{10,} ]]; then
            continue
        fi
        # Add line to current section content
        if [[ -n "$current_content" ]]; then
            current_content+=$'\n'
        fi
        current_content+="$line"
    fi
done <"$CONFIG_FILE"

# Save last section
if [[ -n "$current_section" ]]; then
    sections["$current_section"]="$current_content"
fi

# Merge duplicate sections (e.g., [fetch])
declare -A merged_sections
for section in "${!sections[@]}"; do
    if [[ -n "${merged_sections[$section]:-}" ]]; then
        # Append to existing section, removing leading blank lines
        content="${sections[$section]}"
        content="${content#$'\n'}" # Remove leading newline
        merged_sections[$section]+=$'\n'"$content"
    else
        merged_sections[$section]="${sections[$section]}"
    fi
done

# Output sections in defined order to temp file
TEMP_FILE=$(mktemp)
for item in "${SECTION_ORDER[@]}"; do
    if [[ "$item" == "" ]]; then
        echo ""
    elif [[ "$item" =~ ^# ]]; then
        echo "$item"
    elif [[ -n "${merged_sections[$item]:-}" ]]; then
        echo "$item"
        echo "${merged_sections[$item]}"
    fi
done >"$TEMP_FILE"

# Replace original file
mv "$TEMP_FILE" "$CONFIG_FILE"
echo "✓ Sorted $CONFIG_FILE"
