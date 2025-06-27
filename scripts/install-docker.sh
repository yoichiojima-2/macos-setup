#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

pull_docker_images() {
    local images_file="${1:-config/docker-images.txt}"
    
    if [[ ! -f "$images_file" ]]; then
        log "No Docker images file found, skipping..."
        return 0
    fi
    
    if ! command_exists docker; then
        error "Docker is not installed"
        return 1
    fi
    
    # Check if Docker daemon is running
    if ! docker info >/dev/null 2>&1; then
        log "Docker daemon not running, skipping Docker image pulls"
        log "To pull images later, start Docker and run: docker pull <image-name>"
        return 0
    fi
    
    log "Pulling Docker images..."
    while IFS= read -r image || [[ -n "$image" ]]; do
        [[ -z "$image" || "$image" =~ ^# ]] && continue
        log "Pulling image: $image"
        docker pull "$image" || {
            error "Failed to pull $image"
            # Continue with other images instead of failing
        }
    done < "$images_file"
    success "Docker images pulled"
}

pull_container_images() {
    local containers_file="${1:-config/containers.txt}"
    
    if [[ ! -f "$containers_file" ]]; then
        log "No container images file found, skipping..."
        return 0
    fi
    
    if ! command_exists container; then
        log "Container runtime not found, skipping container images..."
        return 0
    fi
    
    log "Pulling container images..."
    while IFS= read -r image || [[ -n "$image" ]]; do
        [[ -z "$image" || "$image" =~ ^# ]] && continue
        log "Pulling container image: $image"
        container images pull "$image" || {
            error "Failed to pull container image $image"
            # Continue with other images instead of failing
        }
    done < "$containers_file"
    success "Container images pulled"
}

main() {
    pull_docker_images "${1:-}"
    pull_container_images "${2:-}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"