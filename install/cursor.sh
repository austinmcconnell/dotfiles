#!/bin/bash

# ---------------------------------------------------------------
# Cursor IDE Installation Script
# This script:
# 1. Creates necessary Cursor configuration directories
# 2. Links configuration files from the dotfiles repository
# 3. Sets up global AI agent guidelines
# ---------------------------------------------------------------

set -euo pipefail

# Source the utilities script for helper functions
source "$DOTFILES_DIR/install/utils.sh"

print_header "Configuring Cursor IDE"

# Define Cursor configuration directories
# Cursor supports XDG Base Directory Specification
# Global config: ~/.config/cursor/ or ~/.cursor/
CURSOR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cursor"
CURSOR_RULES_DIR="$CURSOR_CONFIG_DIR/rules"
CURSOR_LEGACY_DIR="$HOME/.cursor"
CURSOR_LEGACY_RULES_DIR="$CURSOR_LEGACY_DIR/rules"

# Create necessary directories
mkdir -p "$CURSOR_CONFIG_DIR"
mkdir -p "$CURSOR_RULES_DIR"

# Also create legacy directory for compatibility
mkdir -p "$CURSOR_LEGACY_DIR"
mkdir -p "$CURSOR_LEGACY_RULES_DIR"

# Link global AI agent guidelines directly to rules directory
# Cursor reads .mdc files from the rules/ directory
if [ -f "$DOTFILES_DIR/etc/ai-prompts/agents.md" ]; then
    ln -sfv "$DOTFILES_DIR/etc/ai-prompts/agents.md" "$CURSOR_RULES_DIR/agents.mdc"
    # Also link to legacy location for compatibility
    ln -sfv "$DOTFILES_DIR/etc/ai-prompts/agents.md" "$CURSOR_LEGACY_RULES_DIR/agents.mdc"
    echo "✓ Linked Cursor AI agent guidelines"
else
    echo "⚠️  agents.md not found in dotfiles"
fi

echo "✅ Cursor IDE configuration completed"
echo ""
echo "Note: Cursor will automatically use the rules in:"
echo "  - $CURSOR_RULES_DIR/ (XDG-compliant location)"
echo "  - $CURSOR_LEGACY_RULES_DIR/ (legacy location for compatibility)"
echo ""
echo "The agents.mdc rule file instructs Cursor to follow the guidelines"
echo "in ~/.dotfiles/etc/ai-prompts/agents.md"
