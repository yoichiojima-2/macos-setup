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
    dotfiles_dir="${HOME}/Developer/repo/dotfiles"

    if [[ -f "${dotfiles_dir}/zshrc" ]]; then
        # Remove existing .zshrc if it's not already a symlink to our dotfile
        if [[ -L "${HOME}/.zshrc" && "$(readlink "${HOME}/.zshrc")" == "${dotfiles_dir}/zshrc" ]]; then
            success "Custom .zshrc already linked to dotfiles"
        else
            # Backup existing .zshrc if it exists and is not a symlink
            if [[ -f "${HOME}/.zshrc" && ! -L "${HOME}/.zshrc" ]]; then
                log "Backing up existing .zshrc to .zshrc.backup"
                mv "${HOME}/.zshrc" "${HOME}/.zshrc.backup"
            fi

            # Create symlink
            ln -sf "${dotfiles_dir}/zshrc" "${HOME}/.zshrc"
            success "Custom .zshrc linked to dotfiles"
        fi
    else
        error "zshrc not found in ${dotfiles_dir}"
        return 1
    fi
}

main() {
    install_oh_my_zsh
    install_zshrc
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"