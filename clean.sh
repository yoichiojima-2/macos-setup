#!/bin/zsh


clean() {
    find . -name "__pycache__" -print -exec rm -rf {} +
    find . -name ".pytest_cache" -print -exec rm -rf {} +
}

pre_commit() {
    clean
    source ~/python-venv/general-purpose/bin/activate
    ruff check --fix
    ruff format
}
