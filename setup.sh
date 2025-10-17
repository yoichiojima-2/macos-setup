#!/usr/bin/env bash
set -euo pipefail

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config/settings.sh"
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# Simple logging
log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }
error() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2; }
success() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✓ $*"; }

# ============================================================================
# XCODE COMMAND LINE TOOLS
# ============================================================================
install_xcode_tools() {
    log "=== Checking Xcode Command Line Tools ==="

    if ! xcode-select -p >/dev/null 2>&1; then
        log "Command Line Tools not found, installing..."
        xcode-select --install
        log "Please complete the installation dialog and re-run this script"
        exit 0
    fi

    # Check for Swift SDK mismatch (common on beta macOS)
    if ! /usr/bin/swift --version >/dev/null 2>&1; then
        error "Swift compiler has issues, may need to reinstall Command Line Tools"
        log "Run: sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install"
    else
        log "Command Line Tools OK"
    fi
}

# ============================================================================
# HOMEBREW
# ============================================================================
install_homebrew() {
    log "=== Installing Homebrew ==="

    if command -v brew >/dev/null 2>&1; then
        log "Homebrew already installed"
    else
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for Apple Silicon
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

    # Install formulae
    if [[ -f "${SCRIPT_DIR}/config/brew-formulae.txt" ]]; then
        log "Installing formulae..."
        while IFS= read -r item || [[ -n "$item" ]]; do
            [[ -z "$item" || "$item" =~ ^# ]] && continue

            # Check if already installed
            if brew list --formula "$item" >/dev/null 2>&1; then
                log "Already installed: $item"
            else
                brew install "$item" || true
            fi
        done < "${SCRIPT_DIR}/config/brew-formulae.txt"
    fi

    # Install casks
    if [[ -f "${SCRIPT_DIR}/config/brew-casks.txt" ]]; then
        log "Installing casks..."
        while IFS= read -r item || [[ -n "$item" ]]; do
            [[ -z "$item" || "$item" =~ ^# ]] && continue

            # Check if already installed
            if brew list --cask "$item" >/dev/null 2>&1; then
                log "Already installed: $item"
            else
                brew install --cask "$item" || true
            fi

            # Fix docker linking issue
            if [[ "$item" == "docker" ]]; then
                brew link docker 2>/dev/null || true
            fi
        done < "${SCRIPT_DIR}/config/brew-casks.txt"
    fi

    success "Homebrew setup complete"
}

# ============================================================================
# SHELL (ZSH)
# ============================================================================
install_zsh() {
    log "=== Setting up Zsh ==="

    # Install Oh My Zsh
    if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log "Oh My Zsh already installed"
    fi

    # Link zshrc from dotfiles
    if [[ -f "${DOTFILES_DIR}/zshrc" ]]; then
        ln -sf "${DOTFILES_DIR}/zshrc" "${HOME}/.zshrc"
        log "Linked .zshrc from dotfiles"
    fi

    success "Zsh setup complete"
}

# ============================================================================
# NEOVIM
# ============================================================================
install_neovim() {
    log "=== Setting up Neovim ==="

    mkdir -p "${HOME}/.config/nvim"

    # Link config from dotfiles
    if [[ -f "${DOTFILES_DIR}/init.lua" ]]; then
        ln -sf "${DOTFILES_DIR}/init.lua" "${HOME}/.config/nvim/init.lua"
        log "Linked init.lua from dotfiles"
    elif [[ -f "${DOTFILES_DIR}/init.vim" ]]; then
        ln -sf "${DOTFILES_DIR}/init.vim" "${HOME}/.config/nvim/init.vim"
        log "Linked init.vim from dotfiles"
    fi

    success "Neovim setup complete"
}

# ============================================================================
# VS CODE
# ============================================================================
install_vscode() {
    log "=== Setting up VS Code ==="

    if ! command -v code >/dev/null 2>&1; then
        if [[ -d "/Applications/Visual Studio Code.app" ]]; then
            sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" /usr/local/bin/code
        fi
    fi

    # Install extensions
    if [[ -f "${SCRIPT_DIR}/config/code-extensions.txt" ]] && command -v code >/dev/null 2>&1; then
        log "Installing VS Code extensions..."
        while IFS= read -r ext || [[ -n "$ext" ]]; do
            [[ -z "$ext" || "$ext" =~ ^# ]] && continue
            code --install-extension "$ext" || true
        done < "${SCRIPT_DIR}/config/code-extensions.txt"
    fi

    success "VS Code setup complete"
}

# ============================================================================
# PYTHON
# ============================================================================
install_python() {
    log "=== Setting up Python ==="

    # Initialize pyenv
    if command -v pyenv >/dev/null 2>&1; then
        eval "$(pyenv init -)"

        # Install Python version if needed
        if ! pyenv versions | grep -q "${PYTHON_VERSION}"; then
            log "Installing Python ${PYTHON_VERSION}..."
            pyenv install "${PYTHON_VERSION}"
        fi

        pyenv global "${PYTHON_VERSION}"
    fi

    # Create virtual environment
    if [[ ! -d "${PYTHON_VENV}" ]]; then
        log "Creating Python virtual environment..."
        mkdir -p "$(dirname "${PYTHON_VENV}")"
        python3 -m venv "${PYTHON_VENV}"
    fi

    # Install packages
    if [[ -f "${SCRIPT_DIR}/config/python-requirements.txt" ]]; then
        log "Installing Python packages..."
        "${PYTHON_VENV}/bin/pip" install --upgrade pip
        "${PYTHON_VENV}/bin/pip" install -r "${SCRIPT_DIR}/config/python-requirements.txt"
    fi

    success "Python setup complete"
}

# ============================================================================
# NODE.JS
# ============================================================================
install_node() {
    log "=== Setting up Node.js ==="

    # Load nvm
    export NVM_DIR="${HOME}/.nvm"
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

    if command -v nvm >/dev/null 2>&1; then
        log "Installing Node.js ${NODE_VERSION}..."
        nvm install "${NODE_VERSION}"
        nvm use "${NODE_VERSION}"
        nvm alias default "${NODE_VERSION}"

        # Install global packages
        if [[ -f "${SCRIPT_DIR}/config/node-modules.txt" ]]; then
            log "Installing global npm packages..."
            while IFS= read -r pkg || [[ -n "$pkg" ]]; do
                [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
                npm install -g "$pkg" || true
            done < "${SCRIPT_DIR}/config/node-modules.txt"
        fi
    fi

    success "Node.js setup complete"
}

# ============================================================================
# DOCKER
# ============================================================================
setup_docker() {
    log "=== Setting up Docker ==="

    if ! docker info >/dev/null 2>&1; then
        log "Docker daemon not running, skipping image pulls"
        log "Start Docker Desktop and run: make docker"
        return 0
    fi

    # Pull docker images
    if [[ -f "${SCRIPT_DIR}/config/docker-images.txt" ]]; then
        log "Pulling Docker images..."
        while IFS= read -r image || [[ -n "$image" ]]; do
            [[ -z "$image" || "$image" =~ ^# ]] && continue
            docker pull "$image" || true
        done < "${SCRIPT_DIR}/config/docker-images.txt"
    fi

    success "Docker setup complete"
}

# ============================================================================
# MAIN
# ============================================================================
main() {
    local component="${1:-all}"

    # Always check Xcode Command Line Tools first
    install_xcode_tools

    case "$component" in
        all)
            install_homebrew
            install_zsh
            install_neovim
            install_vscode
            install_python
            install_node
            setup_docker
            success "🎉 Complete setup finished!"
            ;;
        brew|homebrew)
            install_homebrew
            ;;
        zsh|shell)
            install_zsh
            ;;
        vi|vim|neovim)
            install_neovim
            ;;
        code|vscode)
            install_vscode
            ;;
        python)
            install_python
            ;;
        node|nodejs)
            install_node
            ;;
        docker)
            setup_docker
            ;;
        xcode)
            # Already checked above
            ;;
        *)
            error "Unknown component: $component"
            echo "Usage: $0 [all|brew|zsh|vi|code|python|node|docker|xcode]"
            exit 1
            ;;
    esac
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
