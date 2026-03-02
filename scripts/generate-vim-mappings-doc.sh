#!/usr/bin/env bash

# Generate documentation for Vim mappings from plugin configs

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
VIM_DIR="$DOTFILES_DIR/etc/vim"
OUTPUT_FILE="$DOTFILES_DIR/docs/VimMappings.md"

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
            line=$(echo "$line" | sed 's/|.*$//' | xargs)

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
            echo "| Mode | Key | Command | Notes |"
            echo "|------|-----|---------|-------|"
        } >>"$OUTPUT_FILE"

        extract_mappings "$VIM_DIR/.vimrc" | sort -t'|' -k2 | while IFS='|' read -r mode key command plugin override; do
            echo "| $mode | \`$key\` | \`$command\` | $override |" >>"$OUTPUT_FILE"
        done
        echo "" >>"$OUTPUT_FILE"
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
                echo "| Mode | Key | Command | Notes |"
                echo "|------|-----|---------|-------|"
            } >>"$OUTPUT_FILE"

            echo "$mappings" | sort -t'|' -k2 | while IFS='|' read -r mode key command plugin override; do
                echo "| $mode | \`$key\` | \`$command\` | $override |" >>"$OUTPUT_FILE"
            done
            echo "" >>"$OUTPUT_FILE"
        fi
    done

    # Add summary of overrides
    cat >>"$OUTPUT_FILE" <<'EOF'
## Standard Vim Overrides

These mappings override standard Vim behavior. Consider remapping to preserve standard functionality:

EOF

    # Find all overrides
    {
        extract_mappings "$VIM_DIR/.vimrc"
        for file in "$VIM_DIR/plugin"/*.vim; do
            [[ -f "$file" ]] && extract_mappings "$file"
        done
    } | grep "OVERRIDE" | sort -t'|' -k2 | while IFS='|' read -r mode key command plugin override; do
        echo "- \`$key\` ($mode mode): $command - from $plugin" >>"$OUTPUT_FILE"
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

main() {
    echo "Generating Vim mappings documentation..."
    echo "Scanning: $VIM_DIR"

    # Count files
    local plugin_count
    plugin_count=$(find "$VIM_DIR/plugin" -name "*.vim" 2>/dev/null | wc -l | xargs)

    echo "Found: .vimrc + $plugin_count plugin files"

    generate_doc

    # Count mappings
    total_mappings=$(grep -c "^\|" "$OUTPUT_FILE" 2>/dev/null || echo 0)
    echo "✓ Extracted $total_mappings mappings"
    echo "✓ Documentation written to: $OUTPUT_FILE"
}

main
