#!/usr/bin/env bash

# Scan documentation repositories and report project status.
# Derives status from repo structure (ADRs, BOMs, directory population)
# and surfaces todo.md content.
#
# Usage: scan-docs.sh [directory]

set -euo pipefail

DOCS_DIR="${1:-${PROJECTS_DIR:-$HOME/projects}/austinmcconnell/_documentation_}"

# Colors (disabled when not a terminal)
if [[ -t 1 ]]; then
    BOLD='\033[1m'
    DIM='\033[2m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    RESET='\033[0m'
else
    BOLD='' DIM='' GREEN='' YELLOW='' RESET=''
fi

# Pluralize: outputs "s" if count > 1
plural() { [[ "$1" -gt 1 ]] && echo "s" || true; }

# Count .md files in a directory, excluding README.md
count_md() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo 0
        return
    fi
    find "$dir" -maxdepth 1 -name '*.md' ! -name 'README.md' | wc -l | tr -d ' '
}

# Count ADRs by status (reads line 5 of each adr-*.md)
count_adrs() {
    local dir="$1/decisions"
    local status="$2"
    local count=0
    if [[ ! -d "$dir" ]]; then
        echo 0
        return
    fi
    for f in "$dir"/adr-[0-9]*.md; do
        [[ -f "$f" ]] || continue
        local line
        line=$(sed -n '5p' "$f")
        if [[ "$line" == "$status"* ]]; then
            ((count++))
        fi
    done
    echo "$count"
}

# Count BOM items by status (grep table rows)
count_bom() {
    local bom="$1/components/bom.md"
    local status="$2"
    if [[ ! -f "$bom" ]]; then
        echo 0
        return
    fi
    local count
    count=$(grep -c "| ${status} |" "$bom" 2>/dev/null) || true
    echo "${count:-0}"
}

# Count todo.md items by section
count_todo_items() {
    local file="$1"
    local section="$2"
    if [[ ! -f "$file" ]]; then
        echo 0
        return
    fi
    awk -v section="$section" '
        /^## / { in_section = ($0 ~ section) }
        in_section && /^- \[ \]/ { count++ }
        END { print count+0 }
    ' "$file"
}

scan_repo() {
    local repo="$1"
    local name
    name=$(basename "$repo")

    # ADRs
    local accepted proposed superseded
    accepted=$(count_adrs "$repo" "Accepted")
    proposed=$(count_adrs "$repo" "Proposed")
    superseded=$(count_adrs "$repo" "Superseded")

    # BOM
    local bom_bought bom_needed bom_total
    bom_bought=$(count_bom "$repo" "Bought")
    bom_needed=$(count_bom "$repo" "Needed")
    bom_total=$((bom_bought + bom_needed))

    # Directory population
    local research_count components_count config_count procedures_count
    research_count=$(count_md "$repo/research")
    components_count=$(count_md "$repo/components")
    config_count=$(count_md "$repo/configuration")
    procedures_count=$(count_md "$repo/procedures")

    # todo.md
    local todo="$repo/todo.md"
    local open_q blockers tasks
    open_q=$(count_todo_items "$todo" "Open questions")
    blockers=$(count_todo_items "$todo" "Blockers")
    tasks=$(count_todo_items "$todo" "Tasks")

    # Output
    echo -e "${BOLD}${name}${RESET}"

    # ADRs
    local adr_detail=""
    [[ "$accepted" -gt 0 ]] && adr_detail+="${accepted} accepted"
    if [[ "$proposed" -gt 0 ]]; then
        [[ -n "$adr_detail" ]] && adr_detail+=", "
        adr_detail+="${YELLOW}${proposed} proposed${RESET}"
    fi
    if [[ "$superseded" -gt 0 ]]; then
        [[ -n "$adr_detail" ]] && adr_detail+=", "
        adr_detail+="${DIM}${superseded} superseded${RESET}"
    fi
    [[ -z "$adr_detail" ]] && adr_detail="none"
    echo -e "  Decisions:  ${adr_detail}"

    # BOM
    if [[ "$bom_total" -gt 0 ]]; then
        local bom_detail="${GREEN}${bom_bought} bought${RESET}"
        if [[ "$bom_needed" -gt 0 ]]; then
            bom_detail+=", ${YELLOW}${bom_needed} needed${RESET}"
        fi
        echo -e "  Components: ${bom_detail}"
    else
        echo -e "  Components: ${DIM}no BOM entries${RESET}"
    fi

    # Directories
    echo -e "  Content:    research ${research_count}, components ${components_count}, config ${config_count}, procedures ${procedures_count}"

    # todo.md
    if [[ -f "$todo" ]]; then
        local todo_parts=()
        [[ "$open_q" -gt 0 ]] && todo_parts+=("${open_q} question$(plural "$open_q")")
        [[ "$blockers" -gt 0 ]] && todo_parts+=("${YELLOW}${blockers} blocker$(plural "$blockers")${RESET}")
        [[ "$tasks" -gt 0 ]] && todo_parts+=("${tasks} task$(plural "$tasks")")
        if [[ ${#todo_parts[@]} -gt 0 ]]; then
            local joined
            joined=$(printf '%s, ' "${todo_parts[@]}")
            echo -e "  TODO:       ${joined%, }"
        else
            echo -e "  TODO:       ${DIM}all clear${RESET}"
        fi
    fi

    echo
}

# Main
if [[ ! -d "$DOCS_DIR" ]]; then
    echo "Directory not found: $DOCS_DIR" >&2
    exit 1
fi

echo -e "${BOLD}Documentation project status${RESET}"
echo -e "${DIM}$(date '+%Y-%m-%d %H:%M')${RESET}"
echo

for repo in "$DOCS_DIR"/*/; do
    [[ -d "$repo" ]] || continue
    # Skip non-repo directories (must have SUMMARY.md)
    [[ -f "$repo/SUMMARY.md" ]] || continue
    scan_repo "${repo%/}"
done
