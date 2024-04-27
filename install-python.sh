#!/bin/bash


PYTHON_VERSION="3.12"


install_python(){
    pyenv install $PYTHON_VERSION
    pyenv global $PYTHON_VERSION
}


install_python_libraries(){
    python -m venv ~/python-venv/general-purpose
    source ~/python-venv/general-purpose

    pip install --upgrade pip
    pip install -r python-requirements.txt
}

install_python
install_python_libraries
