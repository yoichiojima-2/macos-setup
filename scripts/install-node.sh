#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

install_nvm() {
    if ! command_exists nvm && [[ ! -s "${HOME}/.nvm/nvm.sh" ]]; then
        log "Installing nvm..."
        brew install nvm
        
        # Create nvm directory
        ensure_dir "${HOME}/.nvm"
        
        success "nvm installed"
    else
        log "nvm already installed"
    fi
}

setup_node() {
    log "Setting up Node.js..."
    
    # Source nvm
    export NVM_DIR="${HOME}/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    
    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    
    success "Node.js LTS installed and set as default"
}

update_npm() {
    log "Updating npm..."
    npm update
    npm upgrade
    success "npm updated"
}

install_global_packages() {
    local modules_file="${1:-config/node-modules.txt}"
    
    if [[ ! -f "$modules_file" ]]; then
        log "No global Node modules file found, skipping..."
        return 0
    fi
    
    log "Installing global Node packages..."
    install_from_list "$modules_file" "npm install -g \$item"
    success "Global Node packages installed"
}

main() {
    install_nvm
    setup_node
    update_npm
    install_global_packages "$@"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"