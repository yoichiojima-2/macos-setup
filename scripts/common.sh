#!/usr/bin/env bash

set -euo pipefail

export PYTHON_VENV="${HOME}/Developer/.venv"
export PYTHON_VERSION="3.13"

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