#!/usr/bin/env bash

set -euo pipefail

# Load configuration settings
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/../config/settings.sh"

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    # Fallback values if config file not found
    export PYTHON_VENV="${PYTHON_VENV:-${HOME}/Developer/.venv}"
    export PYTHON_VERSION="${PYTHON_VERSION:-3.13}"
    export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
    export DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/Developer/repo/dotfiles}"
fi

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2
}

success() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✓ $*"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ensure_dir() {
    mkdir -p "$1"
}

download_file() {
    local url="$1"
    local dest="$2"
    log "Downloading $url to $dest"
    curl -fsSL -o "$dest" "$url"
}

install_from_list() {
    local file="$1"
    local install_cmd="$2"
    
    if [[ ! -f "$file" ]]; then
        error "File not found: $file"
        return 1
    fi
    
    while IFS= read -r item || [[ -n "$item" ]]; do
        [[ -z "$item" || "$item" =~ ^# ]] && continue
        log "Installing: $item"
        if eval "$install_cmd" 2>/dev/null; then
            success "Installed: $item"
        else
            error "Failed to install: $item (continuing...)"
        fi
    done < "$file"
}