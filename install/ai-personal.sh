#!/bin/bash

# ---------------------------------------------------------------
# Personal AI Configuration
# Runs after ai-dotfiles install.sh to add personal/work content:
# - Symlinks personal prompts
# - Configures research repo hooks
# - Patches agent JSONs with personal knowledge bases
# ---------------------------------------------------------------

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

AI_DOTFILES_DIR="${AI_DOTFILES_DIR:-$HOME/.ai-dotfiles}"

print_section_header "Configuring personal AI settings"

# --- Symlink personal prompts ---
for prompt in "$DOTFILES_DIR/etc/ai/prompts"/*.md; do
    [ -f "$prompt" ] || continue
    ln -sf "$prompt" "$AI_DOTFILES_DIR/etc/ai/prompts/$(basename "$prompt")"
done
echo "✓ Linked personal prompts"

# --- Research repo KB staleness hooks ---
RESEARCH_REPO="$HOME/projects/austinmcconnell/_research_"
if [ -d "$RESEARCH_REPO/.git" ]; then
    HOOK_CMD="$AI_DOTFILES_DIR/etc/kiro-cli/hooks/kb-staleness.sh"
    git -C "$RESEARCH_REPO" config unset --all hook.kb-staleness.event 2>/dev/null || true
    git -C "$RESEARCH_REPO" config set hook.kb-staleness.command "$HOOK_CMD"
    git -C "$RESEARCH_REPO" config set hook.kb-staleness.event post-commit
    git -C "$RESEARCH_REPO" config set --append hook.kb-staleness.event post-merge
    git -C "$RESEARCH_REPO" config set --append hook.kb-staleness.event post-rewrite
    echo "✓ Configured KB staleness hooks for research repo"
fi

# --- Patch agent JSONs with personal knowledge bases ---
# Agent JSONs must be COPIED (not symlinked) for patching to work.
# The kiro-cli.sh install already symlinks them. We replace symlinks with
# patched copies.
KIRO_AGENTS_DIR="$HOME/.kiro/agents"

if is-executable jq && [ -d "$KIRO_AGENTS_DIR" ]; then
    # Personal KB definitions (adjust paths to your project layout)
    PERSONAL_KBS_DIR="$DOTFILES_DIR/etc/ai/knowledge-bases"

    for kb_file in "$PERSONAL_KBS_DIR"/*.json; do
        [ -f "$kb_file" ] || continue
        agent_name="$(basename "$kb_file" .json)"
        agent_path="$KIRO_AGENTS_DIR/${agent_name}.json"

        if [ -L "$agent_path" ]; then
            # Replace symlink with a copy, then patch
            target="$(readlink "$agent_path")"
            rm "$agent_path"
            cp "$target" "$agent_path"
        fi

        if [ -f "$agent_path" ]; then
            # Merge personal KBs into the resources array
            jq --argjson kbs "$(cat "$kb_file")" \
                '.resources += $kbs' "$agent_path" >"${agent_path}.tmp" &&
                mv "${agent_path}.tmp" "$agent_path"
            echo "✓ Patched $agent_name.json with personal KBs"
        fi
    done
fi

# --- Personal family profile for relocation research ---
FAMILY_PROFILE="$DOTFILES_DIR/etc/ai/skills/research/relocation-research/family-profile.md"
FAMILY_PROFILE_TARGET="$AI_DOTFILES_DIR/etc/ai/skills/research/relocation-research/references/family-profile.md"
if [ -f "$FAMILY_PROFILE" ]; then
    ln -sf "$FAMILY_PROFILE" "$FAMILY_PROFILE_TARGET"
    echo "✓ Linked family profile for relocation research"
fi
