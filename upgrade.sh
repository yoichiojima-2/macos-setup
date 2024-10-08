#!/bin/bash

upgrade() {
    brew upgrade
    pip list | tail -n +3 | awk '{ print $1 }' | xargs pip install --upgrade
    upgrade_python_venv
}

upgrade_python_venv() {
    . ~/python-venv/general-purpose/bin/activate
    pip list | tail -n +3 | awk '{ print $1 }' | xargs pip install --upgrade
}

upgrade
