#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

install_pyenv() {
    if ! command_exists pyenv; then
        log "Installing pyenv..."
        brew install pyenv
        success "pyenv installed"
    else
        log "pyenv already installed"
    fi
}

setup_python_version() {
    log "Setting up Python ${PYTHON_VERSION}..."
    
    # Initialize pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    
    # Check if any version of Python 3.13.x is already installed
    local installed_version=$(pyenv versions | grep -E "${PYTHON_VERSION}\.[0-9]+" | head -1 | sed 's/[* ]//g' | sed 's/(.*$//' | xargs)
    
    if [[ -n "$installed_version" ]]; then
        log "Found compatible Python version: $installed_version"
        PYTHON_VERSION="$installed_version"
    elif ! pyenv versions | grep -q "${PYTHON_VERSION}"; then
        log "Installing Python ${PYTHON_VERSION}..."
        if ! pyenv install "${PYTHON_VERSION}"; then
            error "Failed to install Python ${PYTHON_VERSION}"
            return 1
        fi
    else
        log "Python ${PYTHON_VERSION} already installed"
    fi
    
    pyenv global "${PYTHON_VERSION}"
    success "Python ${PYTHON_VERSION} set as global"
}

create_virtual_env() {
    log "Creating virtual environment at ${PYTHON_VENV}..."
    
    # Remove existing venv if it exists
    if [[ -d "${PYTHON_VENV}" ]]; then
        log "Removing existing virtual environment..."
        rm -rf "${PYTHON_VENV}"
    fi
    
    ensure_dir "$(dirname "${PYTHON_VENV}")"
    python -m venv "${PYTHON_VENV}"
    success "Virtual environment created"
}

install_python_packages() {
    local requirements_file="${1:-config/python-requirements.txt}"
    
    if [[ ! -f "$requirements_file" ]]; then
        error "Requirements file not found: $requirements_file"
        return 1
    fi
    
    log "Upgrading pip..."
    "${PYTHON_VENV}/bin/pip" install --upgrade pip
    
    log "Installing Python packages..."
    "${PYTHON_VENV}/bin/pip" install -r "$requirements_file"
    success "Python packages installed"
}

main() {
    install_pyenv
    setup_python_version
    create_virtual_env
    install_python_packages "$@"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"