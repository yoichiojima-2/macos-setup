#!/bin/bash


install_vscode(){
    brew install --cask visual-studio-code
}


install_vscode_extensions(){
    while read -r extension; do
        code --install-extension $extension
    done < vscode-extensions.txt
}

install_vscode
install_vscode_extensions
