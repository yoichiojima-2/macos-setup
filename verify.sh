#!/usr/bin/env bash

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config/settings.sh"
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_command() {
    local cmd="$1"
    local name="${2:-$cmd}"

    if command_exists "$cmd"; then
        echo -e "${GREEN}✓${NC} $name is installed"
        return 0
    else
        echo -e "${RED}✗${NC} $name is not installed"
        return 1
    fi
}

check_directory() {
    local dir="$1"
    local name="$2"
    
    if [[ -d "$dir" ]]; then
        echo -e "${GREEN}✓${NC} $name exists at $dir"
        return 0
    else
        echo -e "${RED}✗${NC} $name not found at $dir"
        return 1
    fi
}

check_file() {
    local file="$1"
    local name="$2"
    
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $name exists"
        return 0
    else
        echo -e "${RED}✗${NC} $name not found"
        return 1
    fi
}

verify_base_tools() {
    echo -e "\n${YELLOW}Base Tools:${NC}"
    check_command "brew" "Homebrew"
    check_command "git" "Git"
    check_directory "${HOME}/.oh-my-zsh" "Oh My Zsh"
    check_file "${HOME}/.zshrc" "Zsh configuration"
}

verify_editors() {
    echo -e "\n${YELLOW}Editors:${NC}"
    check_command "nvim" "Neovim"
    # Check for either init.lua (modern) or init.vim (legacy)
    if [[ -f "${HOME}/.config/nvim/init.lua" ]]; then
        echo -e "${GREEN}✓${NC} Neovim configuration (init.lua) exists"
    elif [[ -f "${HOME}/.config/nvim/init.vim" ]]; then
        echo -e "${GREEN}✓${NC} Neovim configuration (init.vim) exists"
    else
        echo -e "${RED}✗${NC} Neovim configuration not found"
    fi
    check_command "code" "Visual Studio Code"
}

verify_languages() {
    echo -e "\n${YELLOW}Programming Languages:${NC}"
    
    # Python
    if command_exists "pyenv"; then
        echo -e "${GREEN}✓${NC} pyenv is installed"
        local current_version=$(pyenv version-name 2>/dev/null)
        if [[ "$current_version" == "$PYTHON_VERSION"* ]]; then
            echo -e "${GREEN}✓${NC} Python $PYTHON_VERSION is active"
        else
            echo -e "${YELLOW}!${NC} Python $PYTHON_VERSION not active (current: $current_version)"
        fi
    else
        echo -e "${RED}✗${NC} pyenv is not installed"
    fi
    
    check_directory "$PYTHON_VENV" "Python virtual environment"
    
    # Node.js
    if [[ -s "${HOME}/.nvm/nvm.sh" ]]; then
        echo -e "${GREEN}✓${NC} nvm is installed"
        export NVM_DIR="${HOME}/.nvm"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
        if command_exists "node"; then
            echo -e "${GREEN}✓${NC} Node.js is installed ($(node --version))"
        fi
    else
        echo -e "${RED}✗${NC} nvm is not installed"
    fi
    
    # Other languages
    check_command "rustc" "Rust"
    check_command "java" "Java"
    check_command "psql" "PostgreSQL"
}

verify_containers() {
    echo -e "\n${YELLOW}Container Tools:${NC}"
    check_command "docker" "Docker"
    check_command "container" "Container runtime"
}

verify_cloud_tools() {
    echo -e "\n${YELLOW}Cloud Tools:${NC}"
    check_command "gcloud" "Google Cloud SDK"
    check_command "gh" "GitHub CLI"
}

count_installed_packages() {
    echo -e "\n${YELLOW}Package Counts:${NC}"
    
    if command_exists "brew"; then
        local formulae_count=$(brew list --formula | wc -l | tr -d ' ')
        local cask_count=$(brew list --cask | wc -l | tr -d ' ')
        echo "Homebrew formulae: $formulae_count"
        echo "Homebrew casks: $cask_count"
    fi
    
    if [[ -d "$PYTHON_VENV" ]]; then
        local pip_count=$("$PYTHON_VENV/bin/pip" list | tail -n +3 | wc -l | tr -d ' ')
        echo "Python packages: $pip_count"
    fi
    
    if command_exists "npm"; then
        local npm_count=$(npm list -g --depth=0 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')
        echo "Global npm packages: $npm_count"
    fi
    
    if command_exists "code"; then
        local vscode_count=$(code --list-extensions | wc -l | tr -d ' ')
        echo "VS Code extensions: $vscode_count"
    fi
}

main() {
    echo "=== macOS Development Environment Verification ==="
    echo "Running verification at $(date)"
    
    verify_base_tools
    verify_editors
    verify_languages
    verify_containers
    verify_cloud_tools
    count_installed_packages
    
    echo -e "\n=== Verification Complete ==="
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"