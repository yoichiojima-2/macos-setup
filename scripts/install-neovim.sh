#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

install_neovim() {
    if ! command_exists nvim; then
        log "Installing Neovim..."
        brew install nvim
        success "Neovim installed"
    else
        log "Neovim already installed"
    fi
}

install_vim_plug() {
    local plug_file="${HOME}/.config/nvim/autoload/plug.vim"
    
    if [[ -f "$plug_file" ]]; then
        log "vim-plug already installed"
    else
        log "Installing vim-plug..."
        ensure_dir "${HOME}/.config/nvim/autoload"
        download_file "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$plug_file"
        success "vim-plug installed"
    fi
}

install_nvim_config() {
    log "Installing Neovim configuration..."
    ensure_dir "${HOME}/.config/nvim"
    download_file "https://raw.githubusercontent.com/yoichiojima-2/dotfiles/main/init.vim" "${HOME}/.config/nvim/init.vim"
    success "Neovim configuration installed"
}

install_nvim_plugins() {
    log "Installing Neovim plugins..."
    nvim +PlugInstall +qall
    success "Neovim plugins installed"
}

main() {
    install_neovim
    install_vim_plug
    install_nvim_config
    install_nvim_plugins
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"