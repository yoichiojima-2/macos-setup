#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

check_marketplace_connectivity() {
    log "Checking VS Code marketplace connectivity..."
    
    if ! curl -s --connect-timeout 10 --max-time 30 "https://marketplace.visualstudio.com" > /dev/null; then
        error "Cannot reach VS Code marketplace. Check your internet connection."
        log "Troubleshooting steps:"
        log "1. Check your internet connection"
        log "2. Verify DNS resolution: nslookup marketplace.visualstudio.com"
        log "3. Check if behind corporate firewall/proxy"
        log "4. Try again later - marketplace may be temporarily unavailable"
        return 1
    fi
    
    success "VS Code marketplace is accessible"
    return 0
}

install_vscode() {
    if ! command_exists code; then
        log "Installing Visual Studio Code..."
        brew install --cask visual-studio-code --no-quarantine
        success "Visual Studio Code installed"
    else
        log "Visual Studio Code already installed, skipping brew install"
        # Ensure VS Code is properly linked
        if [[ -L "/opt/homebrew/bin/code" ]]; then
            log "VS Code is properly linked"
        else
            log "Relinking VS Code..."
            brew unlink visual-studio-code 2>/dev/null || true
            brew link visual-studio-code
        fi
    fi
}

install_vscode_extensions() {
    local extensions_file="${1:-config/code-extensions.txt}"
    
    if [[ ! -f "$extensions_file" ]]; then
        error "Extensions file not found: $extensions_file"
        return 1
    fi
    
    # Check marketplace connectivity before attempting installations
    if ! check_marketplace_connectivity; then
        error "Skipping extension installation due to connectivity issues"
        return 1
    fi
    
    log "Installing VS Code extensions..."
    local failed_extensions=()
    
    while IFS= read -r extension || [[ -n "$extension" ]]; do
        [[ -z "$extension" || "$extension" =~ ^# ]] && continue
        log "Installing extension: $extension"
        
        # Try installing with retries
        local attempts=0
        local max_attempts=3
        local success=false
        
        while [[ $attempts -lt $max_attempts ]]; do
            local install_output
            install_output=$(code --install-extension "$extension" --force 2>&1)
            local exit_code=$?
            
            # Check if installation succeeded or extension is already installed
            if [[ $exit_code -eq 0 ]] || [[ $install_output == *"is already installed"* ]]; then
                success=true
                break
            else
                ((attempts++))
                if [[ $attempts -lt $max_attempts ]]; then
                    log "Failed to install $extension, retrying... (attempt $attempts/$max_attempts)"
                    log "Error: $install_output"
                    sleep 2
                fi
            fi
        done
        
        if [[ $success == false ]]; then
            error "Failed to install extension: $extension"
            failed_extensions+=("$extension")
        fi
    done < "$extensions_file"
    
    if [[ ${#failed_extensions[@]} -eq 0 ]]; then
        success "All VS Code extensions installed successfully"
    else
        local total_extensions=$(grep -v '^#' "$extensions_file" | grep -v '^$' | wc -l | tr -d ' ')
        local successful_extensions=$((total_extensions - ${#failed_extensions[@]}))
        
        log "Extension installation summary:"
        log "  ✓ Successfully installed: $successful_extensions/$total_extensions extensions"
        log "  ✗ Failed to install: ${#failed_extensions[@]} extensions"
        log "  Failed extensions: ${failed_extensions[*]}"
        log ""
        log "To retry failed extensions manually:"
        for ext in "${failed_extensions[@]}"; do
            log "  code --install-extension $ext"
        done
        log ""
        log "Note: Extension installation failures are often due to temporary network issues."
        log "VS Code is functional - you can install missing extensions later."
        
        # Don't fail the entire installation for extension failures
        return 0
    fi
}

main() {
    install_vscode
    install_vscode_extensions "$@"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"