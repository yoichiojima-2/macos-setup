#!/bin/bash

install_rust() {
    brew install rustup
    rustup-init
    exec $SHELL
}

install_formatter() {
    rustup component add rustfmt
}

install_evcxr() {
    cargo install evcxr
}

install_rust
install_formatter
install_evcxr
