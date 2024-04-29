#!/bin/bash

install_rust() {
    brew install rustup
    rustup-init
    exec $SHELL
}

install_formatter() {
    rustup component add rustfmt
}

install_rust
install_formatter