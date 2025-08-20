#!/bin/bash

set -euo pipefail

# Source the utilities script
source "$DOTFILES_DIR/install/utils.sh"

if ! is-macos; then
    print_header "Skipping Typora setup: Not macOS"
    return
fi

print_header "Setting up Typora configuration"

# Typora configuration directories
TYPORA_APP_SUPPORT="$HOME/Library/Application Support/abnerworks.Typora"
TYPORA_THEMES_DIR="$TYPORA_APP_SUPPORT/themes"

# Create necessary directories
mkdir -p "$TYPORA_THEMES_DIR"

# Function to extract CSS download URLs from API response
extract_css_urls() {
    local api_response="$1"
    echo "$api_response" | grep '"download_url".*\.css"' | sed 's/.*"download_url": "\([^"]*\)".*/\1/' || true
}

# Function to download CSS files matching theme name
download_css_files() {
    local theme_name="$1"
    local all_css_files="$2"
    local downloaded=false

    for file_url in $all_css_files; do
        if [[ -n "$file_url" ]]; then
            local filename
            filename=$(basename "$file_url")
            local filename_lower
            filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
            local theme_lower
            theme_lower=$(echo "$theme_name" | tr '[:upper:]' '[:lower:]')
            if [[ "$filename_lower" =~ $theme_lower ]]; then
                local local_file="$TYPORA_THEMES_DIR/$filename"

                if [[ ! -f "$local_file" ]]; then
                    echo "Downloading $filename..."
                    if curl -fsSL "$file_url" -o "$local_file"; then
                        echo "✓ Downloaded $filename"
                        downloaded=true
                    else
                        echo "⚠ Failed to download $filename"
                        rm -f "$local_file"
                    fi
                else
                    echo "✓ $filename already exists"
                    downloaded=true
                fi
            fi
        fi
    done

    echo "$downloaded"
}

# Function to download theme directories with supporting files
download_theme_directories() {
    local theme_name="$1"
    local repo_path="$2"
    local theme_dirs="$3"
    local downloaded=false
    local theme_lower
    theme_lower=$(echo "$theme_name" | tr '[:upper:]' '[:lower:]')

    for dir_name in $theme_dirs; do
        local dir_lower
        dir_lower=$(echo "$dir_name" | tr '[:upper:]' '[:lower:]')
        if [[ "$dir_lower" =~ $theme_lower ]]; then
            echo "Downloading theme directory: $dir_name"
            local theme_dir="$TYPORA_THEMES_DIR/$dir_name"
            mkdir -p "$theme_dir"

            local dir_response
            dir_response=$(curl -fsSL "https://api.github.com/repos/$repo_path/contents/$dir_name" 2>/dev/null) || dir_response=""
            local dir_files
            dir_files=$(echo "$dir_response" | grep '"download_url":' | sed 's/.*"download_url": "\([^"]*\)".*/\1/' || true)

            for file_url in $dir_files; do
                if [[ -n "$file_url" && "$file_url" != "null" ]]; then
                    local filename
                    filename=$(basename "$file_url")
                    local local_file="$theme_dir/$filename"

                    if [[ ! -f "$local_file" ]]; then
                        echo "  Downloading $filename..."
                        if curl -fsSL "$file_url" -o "$local_file"; then
                            echo "  ✓ Downloaded $filename"
                            downloaded=true
                        else
                            echo "  ⚠ Failed to download $filename"
                            rm -f "$local_file"
                        fi
                    else
                        echo "  ✓ $filename already exists"
                        downloaded=true
                    fi
                fi
            done
        fi
    done

    echo "$downloaded"
}

# Function to download theme from GitHub repo
download_theme() {
    local theme_name="$1"
    local github_url="$2"

    # Extract owner/repo from GitHub URL
    local repo_path
    repo_path=$(echo "$github_url" | sed -E 's|https://github.com/([^/]+/[^/]+).*|\1|')

    if [[ -z "$repo_path" ]]; then
        echo "⚠ Invalid GitHub URL: $github_url"
        return 1
    fi

    echo "Searching for $theme_name theme files in $repo_path..."

    # Search for CSS files in root directory
    local root_response
    if ! root_response=$(curl -fsSL "https://api.github.com/repos/$repo_path/contents" 2>/dev/null); then
        echo "⚠ Failed to fetch repository contents for $repo_path"
        return 0 # Don't fail the entire script
    fi
    local css_files
    css_files=$(extract_css_urls "$root_response")

    # Search for CSS files in themes directory
    local themes_response
    themes_response=$(curl -fsSL "https://api.github.com/repos/$repo_path/contents/themes" 2>/dev/null) || themes_response=""
    local themes_css_files
    themes_css_files=$(extract_css_urls "$themes_response")

    # Check for theme directories
    local theme_dirs
    theme_dirs=$(echo "$root_response" | grep -B10 '"type": "dir"' | grep '"name":' | sed 's/.*"name": "\([^"]*\)".*/\1/' || true)

    # Download CSS files and theme directories
    local css_downloaded
    css_downloaded=$(download_css_files "$theme_name" "$css_files $themes_css_files")
    local dir_downloaded
    dir_downloaded=$(download_theme_directories "$theme_name" "$repo_path" "$theme_dirs")

    if [[ "$css_downloaded" == false && "$dir_downloaded" == false ]]; then
        echo "⚠ No files found matching '$theme_name' in $repo_path"
    fi
}

# Download popular themes for professional PDF export
echo "Downloading popular themes..."
download_theme "lapis" "https://github.com/YiNNx/typora-theme-lapis"
download_theme "everforest" "https://github.com/EthanBao27/everforest-typora"
download_theme "nord" "https://github.com/ChristosBouronikos/typora-nord-theme"
download_theme "notion" "https://github.com/adrian-fuertes/typora-notion-theme"

echo "✓ Typora configuration complete"
echo "  Themes directory: $TYPORA_THEMES_DIR"
echo "  Select themes in: Typora → Preferences → Appearance"
echo "  Download more themes from: https://theme.typora.io/"
