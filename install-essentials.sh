#!/bin/bash


install_homebrew(){
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}


install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}


install_formulae(){
    casks=(
        "pyenv"
        "rust"
        "google-cloud-sdk"
        "neovim"
        "bat"
        "exa"
        "fd"
        "procs"
        "sd"
        "dust"
        "ripgrep"
    )
    for i in "${casks[@]}"; do
        echo "Installing ${i}"
        brew install $i
    done
}


install_casks(){
    casks=(
        "iterm2"
        "visual-studio-code"
        "soundtoys"
        "ilok-license-manager"
        "waves-central"
    )
    for i in "${casks[@]}"; do
        echo "Installing ${i}"
        brew install --cask $i
    done
}

overwrite_zshrc(){
    cp zshrc ~/.zshrc
    echo "zshrc is overwritten"
}


overwrite_zshrc(){
    cp vimrc ~/.vimrc
    echo "vimrc is overwritten"
}


install_homebrew
install_oh_my_zsh
install_formulae
install_casks
overwrite_zshrc
