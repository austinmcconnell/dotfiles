#!/usr/bin/env bash

# ---------------------------------------------------------------
# Configuration Wizard for Dotfiles
# This script provides an interactive wizard to guide users through
# setting up their dotfiles configuration
# ---------------------------------------------------------------

# Cleanup function for handling interrupts
cleanup() {
    # Remove temporary config if it exists
    if [ -f "$XDG_CONFIG_HOME/dotfiles/config.yaml.tmp" ]; then
        rm -f "$XDG_CONFIG_HOME/dotfiles/config.yaml.tmp"
    fi
    echo -e "\nWizard cancelled. No changes were made."
    exit 1
}

# Set up trap to catch interrupts
trap cleanup SIGINT SIGTERM

# Global variables to store function results
WIZARD_PROFILE=""
WIZARD_MODULES=""
WIZARD_PERSONAL_INFO=""
WIZARD_ADDITIONAL_OPTIONS=""

# Color definitions for better visual feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Print a section header with color
print_header() {
    echo
    echo -e "${BLUE}${BOLD}===================================================${RESET}"
    echo -e "${BLUE}${BOLD} $1${RESET}"
    echo -e "${BLUE}${BOLD}===================================================${RESET}"
    echo
}

# Print a subsection header
print_subheader() {
    echo
    echo -e "${CYAN}${BOLD}$1${RESET}"
    echo -e "${CYAN}${BOLD}$(printf '%*s' "${#1}" "" | tr ' ' '-')${RESET}"
}

# Print success message
print_success() {
    echo -e "${GREEN}✓ $1${RESET}"
}

# Print info message
print_info() {
    echo -e "${BLUE}ℹ $1${RESET}"
}

# Print warning message
print_warning() {
    echo -e "${YELLOW}⚠ $1${RESET}"
}

# Print error message
print_error() {
    echo -e "${RED}✗ $1${RESET}"
}

# Print a step indicator
print_step() {
    echo -e "${MAGENTA}${BOLD}[$1/$2]${RESET} $3"
}

# Welcome screen
show_welcome() {
    clear
    print_header "Welcome to the Dotfiles Configuration Wizard"

    cat <<EOF
This wizard will guide you through setting up your dotfiles configuration.
It will help you:

  • Select a profile that matches your needs
  • Customize which modules are enabled
  • Configure personal preferences
  • Set up your development environment

The process should take about 5 minutes to complete.
EOF

    echo
    read -r -p "Press Enter to begin..."
}

# Step 1: Profile Selection
select_profile() {
    print_step "1" "5" "Profile Selection"

    print_info "A profile is a predefined set of configurations designed for specific use cases."
    echo

    echo -e "${BOLD}Available profiles:${RESET}"
    echo
    echo -e "  ${BOLD}default${RESET}  - Standard configuration for personal use"
    echo "             Includes full development environment, applications, and tools"
    echo
    echo -e "  ${BOLD}work${RESET}     - Configuration optimized for work environment"
    echo "             Similar to default but with work-specific settings and tools"
    echo
    echo -e "  ${BOLD}minimal${RESET}  - Lightweight configuration for servers or minimal setups"
    echo "             Includes only essential tools and configurations"
    echo

    local profile
    while true; do
        read -r -p "Enter profile name [default]: " profile
        profile=${profile:-default}

        if [ "$profile" = "default" ] || [ "$profile" = "work" ] || [ "$profile" = "minimal" ]; then
            echo
            print_success "Selected profile: $profile"
            echo
            WIZARD_PROFILE="$profile"
            return 0
        else
            print_error "Invalid profile. Please choose from: default, work, minimal"
        fi
    done
}

# Step 2: Module Customization
customize_modules() {
    local profile=$1
    print_step "2" "5" "Module Customization"

    print_info "Based on your selected profile ($profile), the following modules will be enabled:"
    echo

    # Create temporary config to use config-manager
    mkdir -p "$XDG_CONFIG_HOME/dotfiles"
    cat >"$XDG_CONFIG_HOME/dotfiles/config.yaml.tmp" <<EOF
# Temporary configuration
profile: $profile
EOF

    # Ensure core config exists
    mkdir -p "$DOTFILES_DIR/etc/core"
    if [ ! -f "$DOTFILES_DIR/etc/core/config.yaml" ]; then
        cp "$DOTFILES_DIR/etc/core/config.yaml.example" "$DOTFILES_DIR/etc/core/config.yaml" 2>/dev/null || true
    fi

    # Get modules that would be enabled with this profile
    local modules
    local enabled_modules=()
    local disabled_modules=()

    # Print our own header
    echo -e "${BOLD}Available modules:${RESET}"
    echo

    if [ -f "$DOTFILES_DIR/etc/core/config.yaml" ]; then
        # Get module list from config-manager but skip the header line
        modules=$("$DOTFILES_DIR/bin/config-manager" list-modules 2>/dev/null | grep -v "Available modules:")

        for module in $modules; do
            # Save the original config file path
            local original_config_file="$USER_CONFIG_FILE"

            # Use the temporary config file for checking if modules are enabled
            if USER_CONFIG_FILE="$XDG_CONFIG_HOME/dotfiles/config.yaml.tmp" "$DOTFILES_DIR/bin/config-manager" is-enabled "$module" 2>/dev/null | grep -q "enabled"; then
                enabled_modules+=("$module")
                echo -e "  ${GREEN}✓${RESET} ${BOLD}$module${RESET}"
            else
                disabled_modules+=("$module")
                echo -e "  ${RED}✗${RESET} $module"
            fi

            # Restore the original config file path
            export USER_CONFIG_FILE="$original_config_file"
        done
    else
        # Fallback if config doesn't exist yet
        case "$profile" in
        "default" | "work")
            enabled_modules=("shell" "package_managers" "development" "system" "applications" "cloud" "ai")
            for module in "${enabled_modules[@]}"; do
                echo -e "  ${GREEN}✓${RESET} ${BOLD}$module${RESET}"
            done
            ;;
        "minimal")
            enabled_modules=("shell" "package_managers" "development" "system")
            disabled_modules=("applications" "cloud" "ai")
            for module in "${enabled_modules[@]}"; do
                echo -e "  ${GREEN}✓${RESET} ${BOLD}$module${RESET}"
            done
            for module in "${disabled_modules[@]}"; do
                echo -e "  ${RED}✗${RESET} $module"
            done
            ;;
        esac
    fi

    echo
    read -r -p "Would you like to customize which modules are enabled? (y/n) [n]: " customize
    customize=${customize:-n}

    local custom_modules=()

    if [[ $customize =~ ^[Yy]$ ]]; then
        echo
        print_subheader "Module Selection"
        print_info "For each module, enter 'y' to enable or 'n' to disable:"

        # Combine all modules
        local all_modules=("${enabled_modules[@]}" "${disabled_modules[@]}")

        for module in "${all_modules[@]}"; do
            local default="n"
            if [[ " ${enabled_modules[*]} " == *" $module "* ]]; then
                default="y"
            fi

            # Show module description
            case "$module" in
            "shell")
                echo -e "\n${BOLD}shell${RESET} - Zsh configuration with plugins and themes"
                ;;
            "package_managers")
                echo -e "\n${BOLD}package_managers${RESET} - System package managers (Homebrew, APT)"
                ;;
            "development")
                echo -e "\n${BOLD}development${RESET} - Programming languages and development tools"
                ;;
            "system")
                echo -e "\n${BOLD}system${RESET} - OS-specific settings and configurations"
                ;;
            "applications")
                echo -e "\n${BOLD}applications${RESET} - Desktop applications and utilities"
                ;;
            "cloud")
                echo -e "\n${BOLD}cloud${RESET} - Cloud service provider tools and configurations"
                ;;
            "ai")
                echo -e "\n${BOLD}ai${RESET} - AI assistant configurations and integrations"
                ;;
            esac

            read -r -p "Enable $module? (y/n) [$default]: " enable
            enable=${enable:-$default}

            if [[ $enable =~ ^[Yy]$ ]]; then
                custom_modules+=("$module")
                echo -e "  ${GREEN}✓${RESET} Module will be enabled"
            else
                echo -e "  ${RED}✗${RESET} Module will be disabled"
            fi
        done
    else
        # Use default modules for the profile
        custom_modules=("${enabled_modules[@]}")
    fi

    # Store the result in the global variable
    WIZARD_MODULES="${custom_modules[*]}"

    # Clean up temporary config file
    if [ -f "$XDG_CONFIG_HOME/dotfiles/config.yaml.tmp" ]; then
        rm -f "$XDG_CONFIG_HOME/dotfiles/config.yaml.tmp"
    fi

    echo
    print_success "Module configuration completed"
}

# Step 3: Personal Information
collect_personal_info() {
    print_step "3" "5" "Personal Information"

    print_info "This information will be used to configure your tools."
    echo

    # Editor preference
    print_subheader "Editor Preference"

    echo "Select your preferred text editor:"
    echo "  1) Vim"
    echo "  2) VS Code"
    echo "  3) Sublime Text"
    echo "  4) Nano"
    echo "  5) Other"

    local editor_choice
    while true; do
        read -r -p "Enter your choice (1-5) [2]: " editor_choice
        editor_choice=${editor_choice:-2}

        if [[ "$editor_choice" =~ ^[1-5]$ ]]; then
            break
        else
            print_error "Please enter a number between 1 and 5."
        fi
    done

    local editor
    case $editor_choice in
    1) editor="vim" ;;
    2) editor="code" ;;
    3) editor="subl" ;;
    4) editor="nano" ;;
    5)
        read -r -p "Enter the command for your preferred editor: " editor
        ;;
    esac

    echo
    print_success "Personal information collected"

    # Store the result in the global variable
    WIZARD_PERSONAL_INFO="$editor"
}

# Step 4: Additional Options
configure_additional_options() {
    print_step "4" "5" "Additional Options"

    local options=()

    # Terminal theme
    print_subheader "Terminal Theme"
    echo "Select your preferred terminal theme:"
    echo "  1) Dark"
    echo "  2) Light"

    local theme_choice
    read -r -p "Enter your choice (1-2) [1]: " theme_choice
    theme_choice=${theme_choice:-1}

    if [ "$theme_choice" = "1" ]; then
        options+=("theme:dark")
    else
        options+=("theme:light")
    fi

    # Shell prompt style
    print_subheader "Shell Prompt Style"
    echo "Select your preferred shell prompt style:"
    echo "  1) Starship (feature-rich, modern)"
    echo "  2) Spaceship (clean, minimal)"
    echo "  3) Classic (simple, fast)"

    local prompt_choice
    read -r -p "Enter your choice (1-3) [1]: " prompt_choice
    prompt_choice=${prompt_choice:-1}

    case $prompt_choice in
    1) options+=("prompt:starship") ;;
    2) options+=("prompt:spaceship") ;;
    3) options+=("prompt:classic") ;;
    esac

    # Python version
    if [[ " $WIZARD_MODULES " == *" development "* ]]; then
        print_subheader "Python Version"
        echo "Select the default Python version to install:"
        echo "  1) Latest (currently 3.12.x)"
        echo "  2) 3.11.x (stable)"
        echo "  3) 3.10.x (older)"
        echo "  4) Skip Python installation"

        local python_choice
        read -r -p "Enter your choice (1-4) [2]: " python_choice
        python_choice=${python_choice:-2}

        case $python_choice in
        1) options+=("python:latest") ;;
        2) options+=("python:3.11") ;;
        3) options+=("python:3.10") ;;
        4) options+=("python:skip") ;;
        esac
    fi

    echo
    print_success "Additional options configured"

    # Store the result in the global variable
    WIZARD_ADDITIONAL_OPTIONS="${options[*]}"
}

# Step 5: Review and Confirm
review_and_confirm() {
    local profile=$1
    local modules=$2
    local editor=$3
    local additional_options=$4

    print_step "5" "5" "Review and Confirm"

    print_info "Please review your configuration before proceeding:"
    echo

    echo -e "${BOLD}Profile:${RESET} $profile"

    echo -e "\n${BOLD}Enabled Modules:${RESET}"
    for module in $modules; do
        echo "  • $module"
    done

    echo -e "\n${BOLD}Personal Information:${RESET}"
    echo "  • Preferred Editor: $editor"

    echo -e "\n${BOLD}Additional Options:${RESET}"
    for option in $additional_options; do
        key="${option%%:*}"
        value="${option#*:}"
        echo "  • ${key^}: $value"
    done

    echo
    read -r -p "Proceed with installation? (y/n) [y]: " confirm
    confirm=${confirm:-y}

    if [[ $confirm =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Save the configuration
save_configuration() {
    local profile=$1
    local modules=$2
    local editor=$3
    local additional_options=$4

    print_header "Saving Configuration"

    # Create user configuration
    mkdir -p "$XDG_CONFIG_HOME/dotfiles"
    cat >"$XDG_CONFIG_HOME/dotfiles/config.yaml" <<EOF
# User configuration for dotfiles
# Generated by the configuration wizard

# Selected profile
profile: $profile

# Module overrides
modules:
EOF

    # Add enabled modules
    for module in $modules; do
        echo "  $module:" >>"$XDG_CONFIG_HOME/dotfiles/config.yaml"
        echo "    enabled: true" >>"$XDG_CONFIG_HOME/dotfiles/config.yaml"
    done

    # Add disabled modules
    local all_modules=("shell" "package_managers" "development" "system" "applications" "cloud" "ai")
    for module in "${all_modules[@]}"; do
        if [[ ! " $modules " == *" $module "* ]]; then
            echo "  $module:" >>"$XDG_CONFIG_HOME/dotfiles/config.yaml"
            echo "    enabled: false" >>"$XDG_CONFIG_HOME/dotfiles/config.yaml"
        fi
    done

    # Save personal preferences
    mkdir -p "$HOME/.extra"

    # Editor preference
    if [ -n "$editor" ]; then
        echo "export EDITOR=\"$editor\"" >"$HOME/.extra/.env"
        echo "export VISUAL=\"$editor\"" >>"$HOME/.extra/.env"
        print_success "Editor preference saved"
    fi

    # Additional options
    for option in $additional_options; do
        key="${option%%:*}"
        value="${option#*:}"

        case "$key" in
        "theme")
            echo "export DOTFILES_THEME=\"$value\"" >>"$HOME/.extra/.env"
            ;;
        "prompt")
            echo "export DOTFILES_PROMPT=\"$value\"" >>"$HOME/.extra/.env"
            ;;
        "python")
            echo "export DOTFILES_PYTHON_VERSION=\"$value\"" >>"$HOME/.extra/.env"
            ;;
        esac
    done

    print_success "Configuration saved successfully"
}

# Main wizard function
run_wizard() {
    # Create a flag to track if we should save the configuration
    local should_save=true

    show_welcome

    # Step 1: Profile Selection
    select_profile || {
        should_save=false
        return 1
    }

    # Step 2: Module Customization
    customize_modules "$WIZARD_PROFILE" || {
        should_save=false
        return 1
    }

    # Step 3: Personal Information
    collect_personal_info || {
        should_save=false
        return 1
    }

    # Step 4: Additional Options
    configure_additional_options || {
        should_save=false
        return 1
    }

    # Step 5: Review and Confirm
    if review_and_confirm "$WIZARD_PROFILE" "$WIZARD_MODULES" "$WIZARD_PERSONAL_INFO" "$WIZARD_ADDITIONAL_OPTIONS"; then
        if [ "$should_save" = true ]; then
            save_configuration "$WIZARD_PROFILE" "$WIZARD_MODULES" "$WIZARD_PERSONAL_INFO" "$WIZARD_ADDITIONAL_OPTIONS"
            return 0
        fi
    else
        print_warning "Installation cancelled. No changes were made."
        return 1
    fi
}

# Export the wizard function
export -f run_wizard
