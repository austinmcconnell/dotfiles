#!/usr/bin/env bash

# Generate documentation for Vim mappings from plugin configs

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
VIM_DIR="$DOTFILES_DIR/etc/vim"
OUTPUT_FILE="$DOTFILES_DIR/etc/vim/vim-mappings.md"

# Extract mappings from a file
extract_mappings() {
    local file=$1
    local plugin_name
    plugin_name=$(basename "$file" .vim)

    # Match various mapping commands: nnoremap, nmap, map, etc.
    grep -E '^\s*([nviclxsto]?(nore)?map|[nviclxsto]map)\s+' "$file" 2>/dev/null |
        grep -v '^\s*"' |
        while IFS= read -r line; do
            # Clean up the line
            line=$(echo "$line" | sed -e 's/|.*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

            # Extract mode from command (nnoremap -> n, map -> all, etc.)
            if [[ "$line" =~ ^([nviclxsto])nore?map ]]; then
                mode="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^([nviclxsto])map ]]; then
                mode="${BASH_REMATCH[1]}"
            elif [[ "$line" =~ ^(nore)?map ]]; then
                mode="all"
            else
                continue
            fi

            # Extract key (handle <leader>, <C-x>, etc.)
            if [[ "$line" =~ map[[:space:]]+([^[:space:]]+)[[:space:]]+ ]]; then
                key="${BASH_REMATCH[1]}"
            else
                continue
            fi

            # Extract command (everything after the key)
            command=$(echo "$line" | sed -E 's/^[a-z]*map[[:space:]]+[^[:space:]]+[[:space:]]+//' | sed 's/</\\</g; s/>/\\>/g')

            # Skip empty commands
            [[ -z "$command" ]] && continue

            # Check if it's a standard Vim override
            override=""
            case "$key" in
            "gd" | "K" | "j" | "k" | "<space>") override="⚠️ OVERRIDE" ;;
            esac

            echo "$mode|$key|$command|$plugin_name|$override"
        done || true # Don't fail if grep finds nothing
}

# Print the length of the longest argument
widest() {
    local longest=0 cell
    for cell in "$@"; do
        if ((${#cell} > longest)); then
            longest=${#cell}
        fi
    done
    echo "$longest"
}

# Print a run of n dashes
dashes() {
    printf '%*s' "$1" '' | tr ' ' '-'
}

# Wrap text in a Markdown code span. A command containing a backtick needs a
# double-backtick fence, or the span closes early and the row renders wrong.
code_span() {
    local tick='`'
    if [[ "$1" == *"$tick"* ]]; then
        printf '%s %s %s' "$tick$tick" "$1" "$tick$tick"
    else
        printf '%s%s%s' "$tick" "$1" "$tick"
    fi
}

# Print a Markdown table from stdin rows of "mode|key|command|plugin|override".
# Columns are padded to their widest cell, the layout mdformat enforces, so the
# generated file passes the formatter unchanged. The plugin field is dropped
# because each table already sits under its plugin heading.
print_mapping_table() {
    local -a modes=(Mode) keys=(Key) commands=(Command) notes=(Notes)
    local mode key command plugin override i
    while IFS='|' read -r mode key command plugin override; do
        modes+=("$mode")
        keys+=("\`$key\`")
        commands+=("$(code_span "$command")")
        notes+=("$override")
    done

    local w1 w2 w3 w4
    w1=$(widest "${modes[@]}")
    w2=$(widest "${keys[@]}")
    w3=$(widest "${commands[@]}")
    w4=$(widest "${notes[@]}")

    for i in "${!modes[@]}"; do
        printf '| %-*s | %-*s | %-*s | %-*s |\n' \
            "$w1" "${modes[i]}" "$w2" "${keys[i]}" "$w3" "${commands[i]}" "$w4" "${notes[i]}"
        if ((i == 0)); then
            printf '| %s | %s | %s | %s |\n' \
                "$(dashes "$w1")" "$(dashes "$w2")" "$(dashes "$w3")" "$(dashes "$w4")"
        fi
    done
}

# Generate markdown
generate_doc() {
    cat >"$OUTPUT_FILE" <<'EOF'
# Vim Mappings Reference

Auto-generated documentation of custom Vim mappings.

**Legend**:

- ⚠️ OVERRIDE: Mapping overrides standard Vim behavior

## Mappings by Plugin

EOF

    # Process .vimrc first
    if [[ -f "$VIM_DIR/.vimrc" ]]; then
        {
            echo "### Core (.vimrc)"
            echo ""
            extract_mappings "$VIM_DIR/.vimrc" | sort -t'|' -k2 | print_mapping_table
            echo ""
        } >>"$OUTPUT_FILE"
    fi

    # Process each plugin file
    for file in "$VIM_DIR/plugin"/*.vim; do
        [[ -f "$file" ]] || continue

        plugin_name=$(basename "$file" .vim)
        mappings=$(extract_mappings "$file")

        if [[ -n "$mappings" ]]; then
            {
                echo "### $plugin_name"
                echo ""
                echo "$mappings" | sort -t'|' -k2 | print_mapping_table
                echo ""
            } >>"$OUTPUT_FILE"
        fi
    done

    # Add summary of overrides
    cat >>"$OUTPUT_FILE" <<'EOF'
## Standard Vim Overrides

These mappings override standard Vim behavior. Consider remapping to preserve standard
functionality:

EOF

    # Find all overrides
    {
        extract_mappings "$VIM_DIR/.vimrc"
        for file in "$VIM_DIR/plugin"/*.vim; do
            [[ -f "$file" ]] && extract_mappings "$file"
        done
    } | grep "OVERRIDE" | sort -t'|' -k2 | while IFS='|' read -r mode key command plugin override; do
        echo "- $(code_span "$key") ($mode mode): $(code_span "$command") - from $plugin" >>"$OUTPUT_FILE"
    done

    cat >>"$OUTPUT_FILE" <<'EOF'

## Mode Reference

- `n`: Normal mode
- `v`: Visual mode
- `i`: Insert mode
- `c`: Command-line mode
- `t`: Terminal mode
- `all`: All modes

## Usage

To check where a mapping was defined at runtime:

```vim
:verbose map <key>
```

To see all mappings:

```vim
:map           " All mappings
:nmap          " Normal mode only
:vmap          " Visual mode only
:imap          " Insert mode only
```
EOF
}

# Count mapping rows in the generated doc. Every table carries a header row and a
# separator row (cell text starts with dashes, which no mode cell does), so both are
# subtracted from the table lines.
count_mapping_rows() {
    local table_lines separator_lines
    table_lines=$(grep -c '^|' "$1" || true)
    separator_lines=$(grep -c '^| -' "$1" || true)
    echo $((table_lines - 2 * separator_lines))
}

main() {
    echo "Generating Vim mappings documentation..."
    echo "Scanning: $VIM_DIR"

    # Count files
    local plugin_count
    plugin_count=$(find "$VIM_DIR/plugin" -name "*.vim" 2>/dev/null | wc -l | xargs)

    echo "Found: .vimrc + $plugin_count plugin files"

    generate_doc

    # Count mappings
    total_mappings=$(count_mapping_rows "$OUTPUT_FILE")
    echo "✓ Extracted $total_mappings mappings"
    echo "✓ Documentation written to: $OUTPUT_FILE"
}

main
