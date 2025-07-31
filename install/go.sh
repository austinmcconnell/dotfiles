#!/bin/bash

if is-executable go; then
    echo "**************************************************"
    echo "Configuring Go"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Go"
        echo "**************************************************"
        brew install go
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Go"
        echo "**************************************************"
        sudo apt install -y golang-go
    else
        echo "**************************************************"
        echo "Skipping Go installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

# Use standard Go directories
GOPATH="$HOME/go"
GOBIN="$GOPATH/bin"
GOCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/go-build"
GOMODCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/go/mod"

# Export environment variables
export GOPATH
export GOBIN
export GOCACHE
export GOMODCACHE

# Create Go directory structure
mkdir -p "$GOPATH"
mkdir -p "$GOBIN"
mkdir -p "$GOCACHE"
mkdir -p "$GOMODCACHE"
mkdir -p "$GOPATH/src"
mkdir -p "$GOPATH/pkg"

# Install essential Go tools
echo "Installing Go development tools..."

# Language server and linting tools
go install golang.org/x/tools/gopls@latest         # Go language server
go install golang.org/x/tools/cmd/goimports@latest # Import formatter (for ALE)
go install golang.org/x/tools/cmd/godoc@latest     # Documentation tool

# Additional useful development tools
go install github.com/go-delve/delve/cmd/dlv@latest  # Debugger
go install honnef.co/go/tools/cmd/staticcheck@latest # Static analysis

echo "Go tools installed successfully!"
echo "GOPATH: $GOPATH"
echo "Go tools are available in: $GOBIN"

# Add Go bin directory to PATH if not already there
if [[ ":$PATH:" != *":$GOBIN:"* ]]; then
    echo "Note: Add $GOBIN to your PATH to use installed Go tools"
fi
