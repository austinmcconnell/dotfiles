#!/bin/bash
set -euo pipefail

# Requires bash 4+ for associative arrays (macOS ships bash 3.2; use Homebrew bash)
if ((BASH_VERSINFO[0] < 4)); then
    echo "Error: drift-check requires bash 4+ (found ${BASH_VERSION}). Install via: brew install bash" >&2
    exit 1
fi

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
source "${DOTFILES_DIR}/install/utils.sh"

STEERING_DIR="${DOTFILES_DIR}/etc/ai/steering"
SKILLS_DIR="${DOTFILES_DIR}/etc/ai/skills"
ALLOWLIST_FILE="${DOTFILES_DIR}/scripts/drift-check-allowlist.txt"
BROKEN=0
WARNINGS=0
OK=0

RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[32m"
BOLD="\033[1m"
RESET="\033[0m"

report_broken() {
    local file="$1" line="$2" category="$3" detail="$4"
    echo -e "  ${RED}[BROKEN]${RESET} ${file}:${line}"
    echo -e "    ${category}: ${detail}"
    ((BROKEN++)) || true
}

report_warning() {
    local file="$1" line="$2" category="$3" detail="$4"
    echo -e "  ${YELLOW}[WARN]${RESET} ${file}:${line}"
    echo -e "    ${category}: ${detail}"
    ((WARNINGS++)) || true
}

report_ok() {
    ((OK++)) || true
}

is_allowlisted() {
    local path_ref="$1"
    [[ -f "$ALLOWLIST_FILE" ]] || return 1
    grep -qxF "$path_ref" "$ALLOWLIST_FILE" 2>/dev/null
}

# Check if a path looks like it should exist in this dotfiles repo
# (starts with etc/, bin/, install/, scripts/, macos/, docs/, tests/, .kiro/)
is_dotfiles_path() {
    local path="$1"
    [[ "$path" =~ ^(etc|bin|install|scripts|macos|docs|tests|\.kiro)/ ]]
}

check_file_paths() {
    echo -e "\n${BOLD}File Path References${RESET}"
    echo "──────────────────────────────────────────────────────────────────────────"

    local in_code_block=false

    while IFS= read -r md_file; do
        local relative_md="${md_file#"${DOTFILES_DIR}/"}"
        local line_num=0
        in_code_block=false

        while IFS= read -r line; do
            ((line_num++)) || true

            # Track code blocks — skip paths inside code blocks (they're examples)
            if [[ "$line" =~ ^\`\`\` ]]; then
                if [[ "$in_code_block" == true ]]; then
                    in_code_block=false
                else
                    in_code_block=true
                fi
                continue
            fi
            [[ "$in_code_block" == true ]] && continue

            # Extract paths from inline code backticks
            # shellcheck disable=SC2016
            while read -r path_ref; do
                [[ -z "$path_ref" ]] && continue
                # Skip URLs and API paths
                [[ "$path_ref" =~ ^https?:// ]] && continue
                [[ "$path_ref" =~ ^/rest/ ]] && continue
                [[ "$path_ref" =~ ^/compact ]] && continue
                # Skip glob patterns
                [[ "$path_ref" =~ ^\*\*/ ]] && continue
                [[ "$path_ref" =~ \*\. ]] && continue
                # Skip regex patterns
                [[ "$path_ref" == '^'* || "$path_ref" == '('* ]] && continue
                # Skip example/placeholder paths
                [[ "$path_ref" =~ ^path/to/ ]] && continue
                [[ "$path_ref" =~ \<.*\> ]] && continue
                # Skip variable references and shell expressions
                [[ "$path_ref" =~ ^\$ ]] && continue
                [[ "$path_ref" =~ ^\{ ]] && continue
                # Skip things that don't look like paths (must contain /)
                [[ "$path_ref" =~ / ]] || continue
                # Skip command-like references (flags, pipes)
                [[ "$path_ref" =~ ^- ]] && continue
                # Skip branch naming patterns
                [[ "$path_ref" =~ ^(feat|fix|chore|docs)/ ]] && continue
                # Skip paths with spaces (likely prose, not real paths)
                [[ "$path_ref" =~ \  ]] && continue
                # Skip generic relative paths not rooted in this repo
                # Only check paths that start with known dotfiles dirs or ~/
                if [[ "$path_ref" != ~/* && "$path_ref" != /* ]]; then
                    is_dotfiles_path "$path_ref" || continue
                fi

                # Check allowlist
                if is_allowlisted "$path_ref"; then
                    report_ok
                    continue
                fi

                # Resolve path
                local resolved=""
                if [[ "$path_ref" == ~/* ]]; then
                    resolved="${path_ref/#\~/$HOME}"
                elif [[ "$path_ref" == /* ]]; then
                    resolved="$path_ref"
                else
                    resolved="${DOTFILES_DIR}/${path_ref}"
                fi

                if [[ -e "$resolved" ]]; then
                    report_ok
                else
                    report_broken "$relative_md" "$line_num" "Path" "$path_ref"
                fi
            done < <(echo "$line" | grep -oE '`[^`]+`' | sed 's/`//g' | grep -E '/' | grep -vE '^\$|^#|^-')

        done <"$md_file"
    done < <(find "$STEERING_DIR" -name '*.md' -type f | sort)
}

check_skill_references() {
    echo -e "\n${BOLD}Skill References${RESET}"
    echo "──────────────────────────────────────────────────────────────────────────"

    while IFS= read -r triggers_file; do
        local relative_file="${triggers_file#"${DOTFILES_DIR}/"}"
        local line_num=0

        while IFS= read -r line; do
            ((line_num++)) || true

            # Match table rows with backtick-quoted skill names (second column)
            if [[ "$line" =~ \|.*\`([a-z0-9-]+)\`.* ]]; then
                local skill_name="${BASH_REMATCH[1]}"

                # Search across all skill categories
                local found=false
                while IFS= read -r skill_dir; do
                    if [[ -f "${skill_dir}/SKILL.md" ]]; then
                        found=true
                        break
                    fi
                done < <(find "$SKILLS_DIR" -type d -name "$skill_name" 2>/dev/null)

                # Also check .kiro/skills/ (project-local)
                if [[ "$found" == false ]]; then
                    while IFS= read -r skill_dir; do
                        if [[ -f "${skill_dir}/SKILL.md" ]]; then
                            found=true
                            break
                        fi
                    done < <(find "${DOTFILES_DIR}/.kiro/skills" -type d -name "$skill_name" 2>/dev/null)
                fi

                if [[ "$found" == true ]]; then
                    report_ok
                else
                    report_broken "$relative_file" "$line_num" "Skill" \
                        "'${skill_name}' — no SKILL.md found"
                fi
            fi
        done <"$triggers_file"
    done < <(find "$STEERING_DIR" -name 'skill-loading-triggers.md' -type f | sort)
}

check_commands() {
    echo -e "\n${BOLD}Command References${RESET}"
    echo "──────────────────────────────────────────────────────────────────────────"

    local -A command_sources=()
    local -a commands_to_check=()

    while IFS= read -r md_file; do
        local relative_md="${md_file#"${DOTFILES_DIR}/"}"
        local line_num=0
        local in_code_block=false
        local code_block_lang=""

        while IFS= read -r line; do
            ((line_num++)) || true

            if [[ "$line" =~ ^\`\`\`(.*) ]]; then
                if [[ "$in_code_block" == true ]]; then
                    in_code_block=false
                    code_block_lang=""
                else
                    in_code_block=true
                    code_block_lang="${BASH_REMATCH[1]}"
                fi
                continue
            fi

            # Only check bash/shell code blocks (skip yaml, text, json, etc.)
            if [[ "$in_code_block" == true ]]; then
                [[ "$code_block_lang" =~ ^(bash|shell|sh|zsh)?$ ]] || continue
                # If lang is empty, skip blocks that look like YAML or text
                if [[ -z "$code_block_lang" ]]; then
                    [[ "$line" =~ ^[[:space:]]*([-]|[a-z_]+:) ]] && continue
                fi

                local cmd
                cmd=$(echo "$line" | sed 's/^[[:space:]]*//' | awk '{print $1}')
                [[ -z "$cmd" ]] && continue
                # Skip comments, variables, control flow, punctuation
                [[ "$cmd" == "#"* || "$cmd" == '$'* || "$cmd" == "|"* ]] && continue
                [[ "$cmd" == "&&" || "$cmd" == "||" ]] && continue
                [[ "$cmd" =~ ^(if|then|fi|done|do|else|elif|for|while|case|esac)$ ]] && continue
                [[ "$cmd" =~ ^(echo|local|export|return|exit|shift|set|source)$ ]] && continue
                [[ "$cmd" == "}" || "$cmd" == "{" || "$cmd" == ")" || "$cmd" == "(" ]] && continue
                # Skip tree-drawing characters and YAML-like content
                [[ "$cmd" == "├──" || "$cmd" == "└──" || "$cmd" == "│" ]] && continue
                [[ "$cmd" == *":" ]] && continue
                [[ "$cmd" == "---" || "$cmd" == ">" ]] && continue
                # Skip things that look like output, not commands
                [[ "$cmd" == "["* ]] && continue

                if [[ -z "${command_sources[$cmd]+_}" ]]; then
                    commands_to_check+=("$cmd")
                    command_sources["$cmd"]="${relative_md}:${line_num}"
                fi
            fi
        done <"$md_file"
    done < <(find "$STEERING_DIR" -name '*.md' -type f | sort)

    for cmd in "${commands_to_check[@]}"; do
        if command -v "$cmd" &>/dev/null; then
            report_ok
        else
            local source="${command_sources[$cmd]}"
            report_warning "${source%%:*}" "${source##*:}" "Command" "'${cmd}' not found in PATH"
        fi
    done
}

check_cross_references() {
    echo -e "\n${BOLD}Cross-References Between Steering Docs${RESET}"
    echo "──────────────────────────────────────────────────────────────────────────"

    while IFS= read -r md_file; do
        local relative_md="${md_file#"${DOTFILES_DIR}/"}"
        local line_num=0
        local in_code_block=false

        # shellcheck disable=SC2094
        while IFS= read -r line; do
            ((line_num++)) || true

            # Skip code blocks
            if [[ "$line" =~ ^\`\`\` ]]; then
                if [[ "$in_code_block" == true ]]; then
                    in_code_block=false
                else
                    in_code_block=true
                fi
                continue
            fi
            [[ "$in_code_block" == true ]] && continue

            # Match markdown links: [text](path)
            while read -r link_target; do
                [[ -z "$link_target" ]] && continue
                # Skip URLs and anchors
                [[ "$link_target" =~ ^https?:// ]] && continue
                [[ "$link_target" == \#* ]] && continue
                # Skip single-word non-path links (like "relative-path", "URL")
                [[ "$link_target" =~ / || "$link_target" =~ \. ]] || continue

                # Strip anchor from path
                local path_only="${link_target%%#*}"
                [[ -z "$path_only" ]] && continue

                # Check allowlist
                if is_allowlisted "$link_target"; then
                    report_ok
                    continue
                fi

                # Resolve relative to the file's directory
                local file_dir
                file_dir=$(dirname "$md_file")
                local resolved="${file_dir}/${path_only}"

                if [[ -e "$resolved" ]]; then
                    report_ok
                else
                    report_broken "$relative_md" "$line_num" "Link" "$link_target"
                fi
            done < <(echo "$line" | grep -oE '\]\([^)]+\)' | sed 's/^\]//' | sed 's/^(//' | sed 's/)$//')

        done <"$md_file"
    done < <(find "$STEERING_DIR" -name '*.md' -type f | sort)
}

main() {
    echo ""
    echo -e "${BOLD}Drift Detection Report${RESET}"
    echo "══════════════════════════════════════════════════════════════════════════"

    check_file_paths
    check_skill_references
    check_commands
    check_cross_references

    echo ""
    echo "══════════════════════════════════════════════════════════════════════════"
    echo -e "Summary: ${RED}${BROKEN} broken${RESET}, ${YELLOW}${WARNINGS} warnings${RESET}, ${GREEN}${OK} OK${RESET}"

    if [[ "$BROKEN" -gt 0 ]]; then
        exit 1
    fi
}

main "$@"
