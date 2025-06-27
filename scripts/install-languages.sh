#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

install_rust() {
    if command_exists rustc; then
        log "Rust already installed"
    else
        log "Installing Rust..."
        # Use rustup via homebrew for better compatibility
        brew install rustup
        
        # Initialize rustup if needed
        if ! rustup show >/dev/null 2>&1; then
            rustup default stable
        fi
        
        success "Rust installed"
    fi
}

install_java() {
    log "Installing Java development tools..."
    
    if ! command_exists java; then
        brew install openjdk
        sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
        success "OpenJDK installed"
    else
        log "Java already installed"
    fi
    
    if ! command_exists hadoop; then
        log "Installing Hadoop..."
        if ! brew install hadoop; then
            log "Hadoop installation had conflicts, attempting to resolve..."
            brew link --overwrite hadoop 2>/dev/null || true
        fi
        success "Hadoop installed"
    else
        log "Hadoop already installed"
    fi
}

install_sql() {
    if command_exists psql; then
        log "PostgreSQL already installed"
    else
        log "Installing PostgreSQL..."
        brew install postgresql@14
        success "PostgreSQL installed"
    fi
}

main() {
    case "${1:-all}" in
        rust)
            install_rust
            ;;
        java)
            install_java
            ;;
        sql)
            install_sql
            ;;
        all)
            install_rust
            install_java
            install_sql
            ;;
        *)
            error "Unknown language: $1"
            echo "Usage: $0 [rust|java|sql|all]"
            exit 1
            ;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"