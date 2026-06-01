#!/bin/bash

# Common utility functions for installation scripts

# --- Logging helpers (LOG_LEVEL: debug, info, error, none) ---
LOG_LEVEL="${DOTFILES_LOG_LEVEL:-info}"

log_debug() {
    if [[ "${LOG_LEVEL}" == "debug" ]]; then
        echo -e "\033[0;37m[DEBUG] $*\033[0m"
    fi
}

log_info() {
    if [[ "${LOG_LEVEL}" == "debug" || "${LOG_LEVEL}" == "info" ]]; then
        echo -e "\033[0;34m[INFO] $*\033[0m"
    fi
}

log_warning() {
    if [[ "${LOG_LEVEL}" != "error" && "${LOG_LEVEL}" != "none" ]]; then
        echo -e "\033[0;33m[WARNING] $*\033[0m" >&2
    fi
}

log_error() {
    if [[ "${LOG_LEVEL}" != "none" ]]; then
        echo -e "\033[0;31m[ERROR] $*\033[0m" >&2
    fi
}

print_section_header() {
    if [[ "${LOG_LEVEL}" != "none" ]]; then
        echo "**********************************************************************"
        echo -e "\033[1;36m[SECTION] $1\033[0m"
        echo "**********************************************************************"
    fi
}
