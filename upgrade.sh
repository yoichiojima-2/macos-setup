#!/bin/bash


upgrade_python_libs(){
    pip list | tail -n +3 | awk '{ print $1 }' | xargs pip install --upgrade
}

upgrade_python_venv() {
    . ~/python-venv/general-purpose/bin/activate
    upgrade_python_libs
}

upgrade() {
    brew upgrade
    upgrade_python_libs
    upgrade_python_venv
}

upgrade
