#!/bin/bash

set -e

# This is now just a wrapper that calls the modular setup script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/kubernetes/setup.sh"
