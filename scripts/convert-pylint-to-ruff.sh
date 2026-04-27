#!/bin/bash

# Script to convert pylint disable comments to ruff noqa comments
# Usage: Run this from any Python project root directory
# Options: --yes or -y to skip interactive prompts
#
# Uses a lookup table to convert each pylint rule to its ruff equivalent.
# Handles any combination of comma-separated rules automatically.
#
# MAPPINGS:
# - unused-argument → ARG001
# - unused-variable → F841
# - unused-import → F401
# - wrong-import-order → I001
# - wrong-import-position → E402
# - broad-exception-caught → BLE001
# - bare-except → E722
# - raise-missing-from → B904
# - invalid-name → (deferred to ruff --add-noqa for precise N8xx codes)
# - constant-name → N816
# - too-many-arguments → PLR0913
# - too-many-locals → PLR0914
# - too-many-statements → PLR0915
# - too-many-branches → PLR0912
# - too-many-return-statements → PLR0911
# - line-too-long → E501
# - trailing-whitespace → W291
# - eval-used → S307
# - exec-used → S102
#
# SILENTLY DROPPED (no ruff equivalent, usually noise):
# - too-few-public-methods, redefined-outer-name
#
# DEFERRED TO RUFF (stripped, then ruff --add-noqa adds precise codes):
# - invalid-name → exact N8xx code(s) determined by ruff
#
# PRESERVED AS COMMENTS (no ruff equivalent, worth keeping):
# - duplicate-code, import-error, no-member
# - missing-docstring, missing-module-docstring
# - missing-class-docstring, missing-function-docstring

set -euo pipefail

# --- Lookup table: pylint rule → ruff code(s) ---
# Empty string = silently drop the suppression comment
# "!" prefix = preserve as a descriptive comment (no noqa)
# shellcheck disable=SC2191
declare -A RULE_MAP=(
    ["unused-argument"]="ARG001"
    ["unused-variable"]="F841"
    ["unused-import"]="F401"
    ["wrong-import-order"]="I001"
    ["wrong-import-position"]="E402"
    ["broad-exception-caught"]="BLE001"
    ["bare-except"]="E722"
    ["raise-missing-from"]="B904"
    ["invalid-name"]=""
    ["constant-name"]="N816"
    ["too-many-arguments"]="PLR0913"
    ["too-many-locals"]="PLR0914"
    ["too-many-statements"]="PLR0915"
    ["too-many-branches"]="PLR0912"
    ["too-many-return-statements"]="PLR0911"
    ["line-too-long"]="E501"
    ["trailing-whitespace"]="W291"
    ["eval-used"]="S307"
    ["exec-used"]="S102"
    # Silently dropped
    ["too-few-public-methods"]=""
    ["redefined-outer-name"]=""
    # Preserved as comments
    ["duplicate-code"]="!duplicate-code (no ruff equivalent)"
    ["import-error"]="!import-error (environment-specific)"
    ["no-member"]="!no-member (often false positive)"
    ["missing-docstring"]="!missing-docstring (enable D rules if needed)"
    ["missing-module-docstring"]="!missing-module-docstring (D100)"
    ["missing-class-docstring"]="!missing-class-docstring (D101)"
    ["missing-function-docstring"]="!missing-function-docstring (D103)"
)

# Parse command line arguments
SKIP_PROMPTS=false
if [[ "${1:-}" == "--yes" ]] || [[ "${1:-}" == "-y" ]]; then
    SKIP_PROMPTS=true
fi

# Files that had invalid-name stripped — ruff will add precise noqa codes
DEFERRED_NOQA_FILES=()

echo "🔄 Converting pylint disable comments to ruff noqa comments..."
echo "📁 Working directory: $(pwd)"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "⚠️  Warning: Not in a git repository. Changes won't be tracked."
    if [ "$SKIP_PROMPTS" = false ]; then
        read -r -p "Continue anyway? (y/N): " -n 1 REPLY
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo "   Continuing anyway (--yes flag provided)..."
    fi
fi

# Count existing pylint disables
echo "🔍 Analyzing current pylint disable comments..."
pylint_count=$(grep -r "pylint: disable" --include="*.py" \
    --exclude-dir=".venv" --exclude-dir="venv" . 2>/dev/null | wc -l)
pylint_count=$(echo "${pylint_count}" | tr -d ' ')
echo "📊 Found ${pylint_count} pylint disable comments"

if [ "${pylint_count}" -eq 0 ]; then
    echo "✅ No pylint disable comments found. Nothing to convert."
    exit 0
fi

# Show breakdown of what we found
echo "📋 Breakdown of pylint disable patterns:"
grep -r "pylint: disable" --include="*.py" \
    --exclude-dir=".venv" --exclude-dir="venv" . 2>/dev/null |
    sed 's/.*pylint: disable=//' | sed 's/ *$//' |
    sort | uniq -c | sed 's/^/   /' || true

echo ""
if [ "$SKIP_PROMPTS" = false ]; then
    read -r -p "🚀 Proceed with conversion? (y/N): " -n 1 REPLY
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Conversion cancelled"
        exit 1
    fi
else
    echo "🚀 Proceeding with conversion (--yes flag provided)..."
fi

# Convert a single pylint disable comment to its ruff equivalent.
# Reads comma-separated rules, looks each up, and builds the replacement.
# Join array elements with a separator
join_by() {
    local sep="$1"
    shift
    local first="$1"
    shift
    printf '%s' "${first}" "${@/#/${sep}}"
}

convert_line() {
    local line="$1"

    # Extract the pylint rules portion, stripping trailing whitespace
    local rules_str
    rules_str=$(echo "${line}" | sed 's/.*# pylint: disable=//' | sed 's/ *$//')

    # Split on commas and look up each rule
    local noqa_codes=()
    local comment_parts=()
    local all_dropped=true

    IFS=',' read -ra rules <<<"${rules_str}"
    for rule in "${rules[@]}"; do
        rule=$(echo "${rule}" | tr -d ' ') # trim whitespace
        if [[ -v "RULE_MAP[${rule}]" ]]; then
            local mapped="${RULE_MAP[${rule}]}"
            if [[ -z "${mapped}" ]]; then
                # Silently dropped
                continue
            elif [[ "${mapped}" == !* ]]; then
                # Preserve as comment
                comment_parts+=("${mapped#!}")
                all_dropped=false
            else
                noqa_codes+=("${mapped}")
                all_dropped=false
            fi
        else
            # Unknown rule — preserve for manual review
            comment_parts+=("${rule} (unknown pylint rule)")
            all_dropped=false
        fi
    done

    # Build the replacement
    local prefix="${line%%# pylint: disable=*}"
    # Strip trailing whitespace from prefix
    prefix="${prefix%"${prefix##*[! 	]}"}"

    if [[ ${#noqa_codes[@]} -gt 0 ]] && [[ ${#comment_parts[@]} -gt 0 ]]; then
        local joined_codes
        joined_codes=$(join_by ", " "${noqa_codes[@]}")
        local joined_comments
        joined_comments=$(join_by "; " "${comment_parts[@]}")
        echo "${prefix}  # noqa: ${joined_codes}  # ${joined_comments}"
    elif [[ ${#noqa_codes[@]} -gt 0 ]]; then
        local joined_codes
        joined_codes=$(join_by ", " "${noqa_codes[@]}")
        echo "${prefix}  # noqa: ${joined_codes}"
    elif [[ ${#comment_parts[@]} -gt 0 ]]; then
        local joined_comments
        joined_comments=$(join_by "; " "${comment_parts[@]}")
        echo "${prefix}  # ${joined_comments}"
    elif [[ "${all_dropped}" == true ]]; then
        # All rules were silently dropped — remove the comment entirely
        echo "${prefix}"
    fi
}

echo "🔧 Converting comments..."

# Process each Python file that contains pylint disable comments
file_count=0
converted_count=0

while IFS= read -r -d '' pyfile; do
    if ! grep -q "pylint: disable" "${pyfile}"; then
        continue
    fi

    file_count=$((file_count + 1))
    local_count=0
    tmpfile="${pyfile}.ruff-tmp"
    has_invalid_name=false

    while IFS= read -r line; do
        if echo "${line}" | grep -q "# pylint: disable="; then
            if echo "${line}" | grep -q "invalid-name"; then
                has_invalid_name=true
            fi
            convert_line "${line}" >>"${tmpfile}"
            local_count=$((local_count + 1))
        else
            echo "${line}" >>"${tmpfile}"
        fi
    done <"${pyfile}"

    mv "${tmpfile}" "${pyfile}"
    converted_count=$((converted_count + local_count))
    if [[ "${has_invalid_name}" == true ]]; then
        DEFERRED_NOQA_FILES+=("${pyfile}")
    fi
    echo "   ${pyfile}: ${local_count} comment(s) converted"
done < <(find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" -print0)

echo ""
echo "✅ Done! Converted ${converted_count} comments across ${file_count} files."

# Second pass: let ruff add precise N8xx noqa codes for invalid-name
if [[ ${#DEFERRED_NOQA_FILES[@]} -gt 0 ]]; then
    if command -v ruff &>/dev/null; then
        echo "🔍 Adding precise naming noqa codes via ruff..."
        ruff check --select N801,N802,N803,N806 --add-noqa "${DEFERRED_NOQA_FILES[@]}" 2>&1 |
            sed 's/^/   /'
        echo "✅ Precise N8xx noqa codes added to ${#DEFERRED_NOQA_FILES[@]} file(s)."
    else
        echo "⚠️  ruff not found. Files with invalid-name had comments stripped but need"
        echo "   manual noqa addition. Run: ruff check --select N801,N802,N803,N806 --add-noqa"
        printf '   %s\n' "${DEFERRED_NOQA_FILES[@]}"
    fi
fi

# Third pass: remove stale noqa comments that no longer suppress anything
if command -v ruff &>/dev/null; then
    echo "🧹 Removing stale noqa comments..."
    ruff check --extend-select RUF100 --fix \
        --exclude ".venv" --exclude "venv" . 2>&1 |
        sed 's/^/   /'
fi

echo "💡 Review changes with: git diff"
