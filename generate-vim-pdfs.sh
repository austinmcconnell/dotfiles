#!/bin/bash
set -euo pipefail

# Generate PDFs from Vim reference text files using enscript + ps2pdf
# Converts UTF-8 box characters to ASCII for compatibility
# Ensures exactly 60 lines per page with clean page breaks

# Check dependencies
if ! command -v enscript &>/dev/null || ! command -v ps2pdf &>/dev/null; then
    echo "Error: Install required tools with: brew install enscript ghostscript"
    exit 1
fi

# Configuration
FONT="Courier10"
MARGINS="36:36:36:36" # 0.5 inches (36 points) on all sides
LINES_PER_PAGE=61     # enscript needs 61 to get 60-line pages

# Files to convert
FILES=(
    "vim-beginner.txt"
    "vim-intermediate.txt"
    "vim-advanced.txt"
    "vim-complete.txt"
)

echo "Generating PDFs with enscript + ps2pdf..."
echo "Settings: Font=$FONT, Margins=$MARGINS, Lines/page=$LINES_PER_PAGE"
echo

for file in "${FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Warning: $file not found, skipping"
        continue
    fi

    output="${file%.txt}.pdf"
    echo "Converting $file -> $output"

    # Convert UTF-8 box chars to ASCII equivalents
    sed 's/═/=/g; s/─/-/g' "$file" >"${file}.ascii"

    enscript "${file}.ascii" \
        --font="$FONT" \
        --margins="$MARGINS" \
        --no-header \
        --lines-per-page="$LINES_PER_PAGE" \
        --output=- 2>/dev/null | ps2pdf - "$output"

    rm "${file}.ascii"
    echo "  ✓ Created $output"
done

echo
echo "Done! Generated PDFs:"
ls -lh vim-*.pdf
