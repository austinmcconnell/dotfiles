#!/bin/bash

# Script to convert pylint disable comments to ruff noqa comments
# Usage: Run this from any Python project root directory
# Options: --yes or -y to skip interactive prompts
#
# This script converts common pylint disable patterns to their ruff equivalents:
#
# BASIC PATTERNS:
# - unused-argument → ARG001
# - unused-variable → F841
# - unused-import → F401
# - broad-exception-caught → BLE001
# - line-too-long → E501
# - wrong-import-order → I001
# - missing-docstring → D100-D107 (commented - ruff doesn't enable by default)
# - invalid-name → N806, N802, N801
# - too-many-* → PLR0913, PLR0915, PLR0912, etc.
# - redefined-outer-name → PLW0621
# - import-error → (commented - often environment-specific)
# - no-member → (commented - often false positive)
# - duplicate-code → (commented - no ruff equivalent)

set -e

# Parse command line arguments
SKIP_PROMPTS=false
if [[ "$1" == "--yes" ]] || [[ "$1" == "-y" ]]; then
    SKIP_PROMPTS=true
fi

echo "🔄 Converting pylint disable comments to ruff noqa comments..."
echo "📁 Working directory: $(pwd)"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "⚠️  Warning: Not in a git repository. Changes won't be tracked."
    if [ "$SKIP_PROMPTS" = false ]; then
        read -p "Continue anyway? (y/N): " -n 1 -r
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
pylint_count=$(grep -r "pylint: disable" --include="*.py" --exclude-dir=".venv" --exclude-dir="venv" . 2>/dev/null | wc -l || echo "0")
echo "📊 Found $pylint_count pylint disable comments"

if [ "$pylint_count" -eq 0 ]; then
    echo "✅ No pylint disable comments found. Nothing to convert."
    exit 0
fi

# Show breakdown of what we found
echo "📋 Breakdown of pylint disable patterns:"
grep -r "pylint: disable" --include="*.py" --exclude-dir=".venv" --exclude-dir="venv" . 2>/dev/null | sed 's/.*pylint: disable=//' | sort | uniq -c | sed 's/^/   /' || true

echo ""
if [ "$SKIP_PROMPTS" = false ]; then
    read -p "🚀 Proceed with conversion? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Conversion cancelled"
        exit 1
    fi
else
    echo "🚀 Proceeding with conversion (--yes flag provided)..."
fi

# Helper function to perform sed replacement on Python files
convert_pattern() {
    local pylint_pattern="$1"
    local ruff_pattern="$2"
    local description="$3"

    echo "   Converting $description"
    find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
        -exec sed -i.bak "s/# pylint: disable=$pylint_pattern/# noqa: $ruff_pattern/g" {} \;
}

echo "🔧 Converting comments..."

# BASIC CONVERSIONS (direct mappings)
echo "   Converting basic patterns..."

# Arguments and variables
convert_pattern "unused-argument" "ARG001" "unused-argument → ARG001"
convert_pattern "unused-variable" "F841" "unused-variable → F841"

# Imports
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=unused-import$/# noqa: F401/g' {} \;
convert_pattern "wrong-import-order" "I001" "wrong-import-order → I001"
convert_pattern "wrong-import-position" "E402" "wrong-import-position → E402"

# Exceptions
convert_pattern "broad-exception-caught" "BLE001" "broad-exception-caught → BLE001"
convert_pattern "bare-except" "E722" "bare-except → E722"
convert_pattern "raise-missing-from" "B904" "raise-missing-from → B904"

# Naming conventions
convert_pattern "invalid-name" "N806" "invalid-name → N806"
convert_pattern "constant-name" "N806" "constant-name → N806"

# Code complexity
convert_pattern "too-many-arguments" "PLR0913" "too-many-arguments → PLR0913"
convert_pattern "too-many-locals" "PLR0914" "too-many-locals → PLR0914"
convert_pattern "too-many-statements" "PLR0915" "too-many-statements → PLR0915"
convert_pattern "too-many-branches" "PLR0912" "too-many-branches → PLR0912"
convert_pattern "too-many-return-statements" "PLR0911" "too-many-return-statements → PLR0911"
convert_pattern "too-few-public-methods" "PLR0903" "too-few-public-methods → PLR0903"

# Style and formatting
convert_pattern "line-too-long" "E501" "line-too-long → E501"
convert_pattern "trailing-whitespace" "W291" "trailing-whitespace → W291"

# Security
convert_pattern "eval-used" "S307" "eval-used → S307"
convert_pattern "exec-used" "S102" "exec-used → S102"

# PATTERNS WITH NO DIRECT RUFF EQUIVALENT (preserve as comments)
echo "   Converting patterns with no ruff equivalent..."

find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=duplicate-code/# duplicate-code (no ruff equivalent)/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=import-error/# import-error (environment-specific)/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=no-member/# no-member (often false positive)/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=missing-docstring/# missing-docstring (enable D rules if needed)/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=missing-module-docstring/# missing-module-docstring (D100)/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=missing-class-docstring/# missing-class-docstring (D101)/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=missing-function-docstring/# missing-function-docstring (D103)/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=redefined-outer-name/# redefined-outer-name (no direct ruff equivalent)/g' {} \;

# COMMON COMBINED PATTERNS
echo "   Converting combined patterns..."

find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=unused-import,wrong-import-order/# noqa: F401, I001/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=wrong-import-order,unused-import/# noqa: I001, F401/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=invalid-name,too-many-arguments/# noqa: N806, PLR0913/g' {} \;
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=broad-exception-caught,unused-variable/# noqa: BLE001, F841/g' {} \;

# COMPLEX PATTERNS (handle multiple comma-separated values)
echo "   Converting complex multi-rule patterns..."

# This handles any remaining complex patterns by converting each rule individually
# Note: This is a simplified approach - very complex patterns might need manual review
find . -name "*.py" -not -path "./.venv/*" -not -path "./venv/*" \
    -exec sed -i.bak 's/# pylint: disable=\([^,]*\),\([^,]*\),\([^,]*\)/# noqa: # complex-pattern: \1,\2,\3 (review manually)/g' {} \;

# Clean up sed backup files
find . -name "*.py.bak" -not -path "./.venv/*" -not -path "./venv/*" -delete
