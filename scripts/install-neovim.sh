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

install_nvim_config() {
    log "Installing Neovim configuration..."
    ensure_dir "${HOME}/.config/nvim"
    dotfiles_dir="${HOME}/Developer/repo/dotfiles"

    # Check for init.lua (modern config) first, then init.vim (legacy)
    if [[ -f "${dotfiles_dir}/init.lua" ]]; then
        # Check if files are already identical
        if cmp -s "${dotfiles_dir}/init.lua" "${HOME}/.config/nvim/init.lua" 2>/dev/null; then
            success "Neovim configuration (init.lua) already up to date"
        else
            cp "${dotfiles_dir}/init.lua" "${HOME}/.config/nvim/init.lua"
            success "Neovim configuration (init.lua) installed from local dotfiles"
        fi
        # init.lua typically uses lazy.nvim, which auto-installs
        return 0
    elif [[ -f "${dotfiles_dir}/init.vim" ]]; then
        # Check if files are already identical
        if cmp -s "${dotfiles_dir}/init.vim" "${HOME}/.config/nvim/init.vim" 2>/dev/null; then
            success "Neovim configuration (init.vim) already up to date"
        else
            cp "${dotfiles_dir}/init.vim" "${HOME}/.config/nvim/init.vim"
            success "Neovim configuration (init.vim) installed from local dotfiles"
        fi
        # init.vim might use vim-plug, install it
        install_vim_plug_if_needed
        return 0
    else
        error "Neither init.lua nor init.vim found in ${dotfiles_dir}"
        return 1
    fi
}

install_vim_plug_if_needed() {
    # Check if init.vim uses vim-plug
    if grep -q "plug#begin\|Plug " "${HOME}/.config/nvim/init.vim" 2>/dev/null; then
        local plug_file="${HOME}/.config/nvim/autoload/plug.vim"

        if [[ -f "$plug_file" ]]; then
            log "vim-plug already installed"
        else
            log "Installing vim-plug..."
            ensure_dir "${HOME}/.config/nvim/autoload"
            download_file "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$plug_file"
            success "vim-plug installed"
        fi

        # Install plugins using vim-plug
        log "Installing Neovim plugins via vim-plug..."
        nvim +PlugInstall +qall
        success "Neovim plugins installed"
    fi
}

install_nvim_plugins() {
    log "Syncing Neovim plugins..."

    # For init.lua with lazy.nvim, just open and quit to trigger auto-install
    if [[ -f "${HOME}/.config/nvim/init.lua" ]]; then
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
        success "Neovim plugins synced via lazy.nvim"
    fi

    # For init.vim with vim-plug, the install happens in install_vim_plug_if_needed
}

main() {
    install_neovim
    install_nvim_config
    install_nvim_plugins
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"