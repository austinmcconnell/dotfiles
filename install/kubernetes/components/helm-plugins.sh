#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_helm_plugins() {
    print_section_header "Installing helm plugins"

    if helm plugin list | grep --quiet diff; then
        echo "diff plugin already added"
    else
        helm plugin install https://github.com/databus23/helm-diff
    fi
}

# Install helm plugins
install_helm_plugins

# Update helm repositories
update_helm_repos
