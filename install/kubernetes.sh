#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect cluster state before setup
was_running=false
if k3d cluster list --no-headers 2>/dev/null | grep --quiet "^dev "; then
    if ! k3d cluster list --no-headers | grep --quiet "^dev.*0/1"; then
        was_running=true
    else
        k3d cluster start dev
        kubectl wait --for=condition=ready node --all --timeout=90s
    fi
fi

"$SCRIPT_DIR/kubernetes/setup.sh"

# Restore original state
if [ "$was_running" = false ]; then
    k3d cluster stop dev
fi
