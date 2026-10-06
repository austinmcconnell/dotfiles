#!/bin/bash

set -euo pipefail

source "$DOTFILES_DIR/install/utils.sh"

# ---------------------------------------------------------------
# Scaffold host-local AI-tooling source templates under ~/.extra.
#
# The ai-dotfiles repo reads two optional, host-local, git-ignored files to
# mount machine-specific skills and steering that must stay out of the public
# dotfiles:
#   - ~/.extra/skill-sources     (install/ai-tools.sh)
#   - ~/.extra/steering-sources  (scripts/generate-personas.sh)
#
# Both consumers degrade cleanly when the file is ABSENT (in-repo only, no
# error), so this script never writes a live file — it drops a `.example`
# sibling the user copies to activate. A live steering-sources with an
# uncommented placeholder path would emit a ⚠ SKIPPED warning on every persona
# generation; a `.example` with only commented lines is inert.
#
# The `.example` files are repo-owned templates, not user data (the user's
# edits live in the LIVE skill-sources/steering-sources they copy to). So they
# are refreshed on every run — this is how template improvements reach an
# existing machine. The live files are never written (the script only ever
# touches `.example` names), so user data is safe without a clobber guard.
# ---------------------------------------------------------------

print_section_header "Scaffolding ~/.extra AI source templates"

mkdir -p "$HOME/.extra"

# Write/refresh a repo-owned `.example` template. Rewrites only when the content
# differs, so a no-op run stays quiet and does not bump mtime. Never writes the
# live source file — only its `.example` sibling.
# Usage: scaffold_example <target-path> <<'EOF' ... EOF
scaffold_example() {
    local target="$1" content
    content="$(cat)"
    if [ -f "$target" ] && [ "$content" = "$(cat "$target")" ]; then
        echo "✓ $target already current"
        return
    fi
    printf '%s\n' "$content" >"$target"
    echo "✓ Wrote $target"
}

scaffold_example "$HOME/.extra/skill-sources.example" <<'EOF'
# Host-local skill sources — one `name=path` per line (# comments ok).
#
# Consumed by ai-dotfiles install/ai-tools.sh to mount machine-specific skill
# dirs that are not tracked in the public repo.
#   name = mount label under each agent's `extra/` skills umbrella category.
#   path = a directory containing skill dirs; a leading ~/ is expanded to $HOME.
# A line with no `=` is skipped; leading/trailing whitespace is trimmed.
#
# Env-var equivalent: $EXTRA_SKILL_SOURCES, colon-separated name=path pairs
# (PATH-like). Both the env var and this file are additive.
#
# To activate: copy this file to ~/.extra/skill-sources and uncomment/edit.
# An absent live file is normal — the AI tooling then mounts in-repo skills only.
#
# work=~/work-config/ai-skills
EOF

scaffold_example "$HOME/.extra/steering-sources.example" <<'EOF'
# Host-local steering sources — one `domain=path` per line (# comments ok).
#
# Consumed by ai-dotfiles scripts/generate-personas.sh to inline
# machine-specific steering docs into the matching Claude persona.
#   domain = a steering domain name (e.g. scrum, ansible, documentation, datadog).
#   path   = a directory of *.md steering docs; a leading ~/ is expanded to $HOME.
# A line with no `=` is skipped; leading/trailing whitespace is trimmed.
#
# Env-var equivalent: $EXTRA_STEERING_SOURCES, colon-separated domain=path pairs.
#
# IMPORTANT: a listed path that is missing (or a dir with no *.md) emits a
# non-fatal `⚠ SKIPPED` warning at persona-generation time. An absent live file
# is silent. So keep example lines COMMENTED until the path actually exists —
# an uncommented dead path would warn on every install.
#
# To activate: copy this file to ~/.extra/steering-sources and uncomment/edit.
#
# scrum=~/work-config/ai-steering/scrum
EOF
