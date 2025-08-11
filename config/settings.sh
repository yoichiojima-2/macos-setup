#!/usr/bin/env bash

# Central configuration file for macOS setup
# These can be overridden by environment variables

# Python Configuration
export PYTHON_VERSION="${PYTHON_VERSION:-3.13}"
export PYTHON_VENV="${PYTHON_VENV:-${HOME}/Developer/.venv}"

# Homebrew Configuration
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
    if [[ -d "/opt/homebrew" ]]; then
        export HOMEBREW_PREFIX="/opt/homebrew"
    elif [[ -d "/usr/local" ]]; then
        export HOMEBREW_PREFIX="/usr/local"
    else
        export HOMEBREW_PREFIX="/opt/homebrew"  # Default for Apple Silicon
    fi
fi

# Repository Paths
export DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Developer/repo/dotfiles}"
export VIBE_DIR="${VIBE_DIR:-${HOME}/Developer/repo/vibe}"
export MACOS_SETUP_DIR="${MACOS_SETUP_DIR:-${HOME}/Developer/repo/macos-setup}"

# Node.js Configuration
export NVM_DIR="${NVM_DIR:-${HOME}/.nvm}"
export NODE_VERSION="${NODE_VERSION:-lts/*}"  # Use latest LTS by default

# Java Configuration
export JAVA_HOME="${JAVA_HOME:-${HOMEBREW_PREFIX}/opt/openjdk/libexec/openjdk.jdk/Contents/Home}"

# Development Directory
export DEV_DIR="${DEV_DIR:-${HOME}/Developer}"

# Backup Configuration
export BACKUP_DIR="${BACKUP_DIR:-${HOME}/.config/macos-setup/backups}"
export BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"

# Color Output (set to 0 to disable)
export USE_COLOR="${USE_COLOR:-1}"

# Verbose Mode (set to 1 for detailed output)
export VERBOSE="${VERBOSE:-0}"

# Dry Run Mode (set to 1 to preview without making changes)
export DRY_RUN="${DRY_RUN:-0}"