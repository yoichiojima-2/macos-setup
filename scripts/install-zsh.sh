#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

install_oh_my_zsh() {
    if [[ -d "${HOME}/.oh-my-zsh" ]]; then
        log "Oh My Zsh already installed"
    else
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh installed"
    fi
}

install_zshrc() {
    log "Installing custom .zshrc configuration..."
    download_file "https://raw.githubusercontent.com/yoichiojima-2/dotfiles/main/zshrc" "${HOME}/.zshrc"
    success "Custom .zshrc installed"
}

main() {
    install_oh_my_zsh
    install_zshrc
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"