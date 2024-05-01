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

install_vim
install_plug
copy_init_vim
