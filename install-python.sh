#!/bin/bash


PYTHON_VERSION="3.12"


install_python(){
    pyenv install $PYTHON_VERSION
    pyenv global $PYTHON_VERSION
}


install_python_libraries(){
    python -m venv ~/python-venv/general-purpose
    source ~/python-venv/general-purpose

    libs=(
        "ipython"
        "jupyterlab"
        "black"
        "black[jupyter]"
        "pytest"
    )

    pip install --upgrade pip

    for i in "${libs[@]}"; do
        pip3 install $i
    done
}

install_python
install_python_libraries
