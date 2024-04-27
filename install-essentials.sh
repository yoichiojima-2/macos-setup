#!/bin/bash


install_homebrew(){
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}


install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}


install_formulae(){
    while read -r formula; do
        echo "Installing ${formula}"
        brew install ${formula}
    done < homebrew-formulae.txt
}


install_casks(){
    while read -r cask; do
        echo "Installing ${cask}"
        brew install --cask ${cask}
    done < homebrew-casks.txt
}

overwrite_zshrc(){
    cp zshrc ~/.zshrc
    echo "zshrc is overwritten"
}


overwrite_vimrc(){
    cp vimrc ~/.vimrc
    echo "vimrc is overwritten"
}


install_homebrew
install_oh_my_zsh
install_formulae
install_casks
overwrite_zshrc
overwrite_vimrc
