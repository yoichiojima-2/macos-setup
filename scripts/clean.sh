#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

clean_homebrew() {
    log "Cleaning Homebrew..."
    brew cleanup
    success "Homebrew cleaned"
}

clean_docker() {
    if command_exists docker; then
        log "Cleaning Docker resources..."
        
        # Check if Docker daemon is running
        if ! docker info >/dev/null 2>&1; then
            log "Docker daemon not running, skipping Docker cleanup"
            return 0
        fi
        
        # Stop and remove all containers
        local containers=$(docker ps -aq 2>/dev/null)
        if [[ -n "$containers" ]]; then
            log "Removing Docker containers..."
            docker rm -f $containers 2>/dev/null || true
        fi
        
        # Remove all images
        local images=$(docker images -q 2>/dev/null)
        if [[ -n "$images" ]]; then
            log "Removing Docker images..."
            docker rmi -f $images 2>/dev/null || true
        fi
        
        # Prune system
        docker system prune -af --volumes 2>/dev/null || true
        
        success "Docker resources cleaned"
    else
        log "Docker not found, skipping..."
    fi
}

clean_temp_files() {
    log "Cleaning temporary files..."
    
    # Clean any .installed marker files
    find . -name "*.installed" -type f -delete
    
    success "Temporary files cleaned"
}

main() {
    case "${1:-all}" in
        brew)
            clean_homebrew
            ;;
        docker)
            clean_docker
            ;;
        temp)
            clean_temp_files
            ;;
        all)
            clean_homebrew
            clean_docker
            clean_temp_files
            ;;
        *)
            error "Unknown clean target: $1"
            echo "Usage: $0 [brew|docker|temp|all]"
            exit 1
            ;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"