#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

upgrade_homebrew() {
    log "Updating Homebrew..."
    brew update
    
    log "Upgrading Homebrew packages..."
    brew upgrade
    
    log "Upgrading Homebrew casks..."
    brew upgrade --cask
    
    success "Homebrew packages upgraded"
}

upgrade_python_packages() {
    if [[ -d "${PYTHON_VENV}" ]]; then
        log "Upgrading Python packages..."
        "${PYTHON_VENV}/bin/pip" install --upgrade pip
        
        local requirements_file="config/python-requirements.txt"
        if [[ -f "$requirements_file" ]]; then
            "${PYTHON_VENV}/bin/pip" install --upgrade -r "$requirements_file"
        fi
        
        success "Python packages upgraded"
    else
        log "Python virtual environment not found, skipping..."
    fi
}

upgrade_npm_packages() {
    if command_exists npm; then
        log "Upgrading npm packages..."
        npm update -g
        npm upgrade -g
        success "npm packages upgraded"
    else
        log "npm not found, skipping..."
    fi
}

upgrade_gcloud() {
    if command_exists gcloud; then
        log "Updating Google Cloud SDK..."
        yes | gcloud components update
        success "Google Cloud SDK updated"
    else
        log "gcloud not found, skipping..."
    fi
}

main() {
    upgrade_homebrew
    upgrade_python_packages
    upgrade_npm_packages
    upgrade_gcloud
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
