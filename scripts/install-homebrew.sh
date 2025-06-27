#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

install_homebrew() {
    if command_exists brew; then
        log "Homebrew already installed"
        return 0
    fi
    
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    success "Homebrew installed"
}

install_brew_packages() {
    local formulae_file="${1:-config/brew-formulae.txt}"
    local casks_file="${2:-config/brew-casks.txt}"
    
    if [[ -f "$formulae_file" ]]; then
        log "Installing Homebrew formulae..."
        install_from_list "$formulae_file" "brew install --force \$item"
        success "Homebrew formulae installed"
    fi
    
    if [[ -f "$casks_file" ]]; then
        log "Installing Homebrew casks..."
        install_from_list "$casks_file" "brew install --cask --force \$item"
        success "Homebrew casks installed"
    fi
}

main() {
    install_homebrew
    install_brew_packages "$@"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"