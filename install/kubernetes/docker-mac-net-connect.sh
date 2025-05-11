#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
fi

install_docker_mac_net_connect() {
    # Allows connecting directly to Docker-for-Mac container via their IP address
    # https://github.com/chipmk/docker-mac-net-connect

    print_section_header "Installing docker-mac-net-connect"

    if brew services list | grep -q docker-mac-net-connect; then
        brew services info docker-mac-net-connect
    else
        brew install chipmk/tap/docker-mac-net-connect
        sudo brew services start chipmk/tap/docker-mac-net-connect
    fi

    print_section_header "Testing docker-mac-net-connect"
    sh "$DOTFILES_DIR/etc/kind/test/test-docker-mac-net-connect.sh"
}

# Only run on macOS
if is-macos; then
    install_docker_mac_net_connect
fi
