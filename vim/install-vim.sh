#!/bin/bash

install_vim() {
    brew install neovim
}

install_colorscheme() {
    mkdir -p ~/.vim/colors
    curl -o ~/.vim/colors/github.vim https://raw.githubusercontent.com/cormacrelf/vim-colors-github/master/colors/github.vim
}

overwrite_vimrc() {
    cp vimrc ~/.vimrc
}

install_vim
install_colorscheme
overwrite_vimrc
