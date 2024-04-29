#!/bin/bash

install_nvm() {
    brew install nvm
    mkdir ~/.nvm
}

install_node() {
    source ~/.zshrc
    nvm install node
}

install_nvm
install_node
