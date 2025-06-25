#!/bin/bash

# ---------------------------------------------------------------
# Amazon Q Profile Manager
# This script helps manage Amazon Q profiles in your dotfiles
# ---------------------------------------------------------------

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
AMAZON_Q_PROFILES_DIR="$HOME/.aws/amazonq/profiles"
DOTFILES_PROFILES_DIR="$DOTFILES_DIR/etc/amazon-q/profiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# List all Amazon Q profiles
list_profiles() {
    print_header "Amazon Q Profiles"

    if [ ! -d "$AMAZON_Q_PROFILES_DIR" ]; then
        print_error "Amazon Q profiles directory not found: $AMAZON_Q_PROFILES_DIR"
        return 1
    fi

    echo "Profiles found in Amazon Q:"
    for profile_dir in "$AMAZON_Q_PROFILES_DIR"/*; do
        if [ -d "$profile_dir" ]; then
            profile_name=$(basename "$profile_dir")
            if [ -L "$profile_dir/context.json" ]; then
                echo -e "  ${GREEN}$profile_name${NC} (tracked in dotfiles)"
            else
                echo -e "  ${YELLOW}$profile_name${NC} (not tracked)"
            fi
        fi
    done
}

# Import a profile from Amazon Q to dotfiles
import_profile() {
    local profile_name="$1"
    local source_file="$AMAZON_Q_PROFILES_DIR/$profile_name/context.json"
    local target_dir="$DOTFILES_PROFILES_DIR/$profile_name"
    local target_file="$target_dir/context.json"

    if [ ! -f "$source_file" ]; then
        print_error "Profile '$profile_name' not found in Amazon Q"
        return 1
    fi

    if [ -f "$target_file" ]; then
        print_warning "Profile '$profile_name' already exists in dotfiles"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Import cancelled"
            return 1
        fi
    fi

    # Create target directory
    mkdir -p "$target_dir"

    # Copy the file to dotfiles
    cp "$source_file" "$target_file"

    # Replace the original with a symlink
    rm "$source_file"
    ln -s "$target_file" "$source_file"

    print_success "Imported profile '$profile_name' to dotfiles"
    print_warning "Don't forget to commit the new profile to git!"
}

# Show untracked profiles
show_untracked() {
    print_header "Untracked Profiles"

    local found_untracked=false

    for profile_dir in "$AMAZON_Q_PROFILES_DIR"/*; do
        if [ -d "$profile_dir" ]; then
            profile_name=$(basename "$profile_dir")
            if [ ! -L "$profile_dir/context.json" ]; then
                echo -e "  ${YELLOW}$profile_name${NC}"
                found_untracked=true
            fi
        fi
    done

    if [ "$found_untracked" = false ]; then
        print_success "All profiles are tracked in dotfiles"
    else
        echo -e "\nTo import a profile: $0 import <profile_name>"
    fi
}

# Show help
show_help() {
    echo "Amazon Q Profile Manager"
    echo ""
    echo "Usage: $0 <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  list              List all Amazon Q profiles"
    echo "  untracked         Show profiles not tracked in dotfiles"
    echo "  import <profile>  Import a profile from Amazon Q to dotfiles"
    echo "  help              Show this help message"
}

# Main script logic
case "${1:-help}" in
"list")
    list_profiles
    ;;
"untracked")
    show_untracked
    ;;
"import")
    if [ $# -lt 2 ]; then
        print_error "Profile name required"
        echo "Usage: $0 import <profile_name>"
        exit 1
    fi
    import_profile "$2"
    ;;
"help" | *)
    show_help
    ;;
esac
