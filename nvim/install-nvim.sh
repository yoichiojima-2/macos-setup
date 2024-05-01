#!/bin/bash

install_vim() {
    brew install neovim
}

install_plug() {
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

copy_init_vim() {
    cp init.vim ~/.config/nvim/init.vim
}

install_github_colorscheme() {
    curl -fLo ~/.config/nvim/colors/github-dimmed.vim --create-dirs https://raw.githubusercontent.com/zoomlogo/github-dimmed.vim/master/colors/github-dimmed.vim
}

install_vim
install_plug
copy_init_vim
install_github_colorscheme
