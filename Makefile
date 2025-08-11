# macOS Development Environment Setup
# Usage: make [target]

SHELL := /bin/bash
.DEFAULT_GOAL := help

# Make all scripts executable
$(shell chmod +x scripts/*.sh)

# Configuration is loaded by individual scripts via common.sh

.PHONY: help
help:
	@echo "macOS Development Environment Setup"
	@echo ""
	@echo "Usage:"
	@echo "  make all        - Complete setup (installs everything)"
	@echo "  make brew       - Install Homebrew and packages"
	@echo "  make zsh        - Install Oh My Zsh and custom config"
	@echo "  make vi         - Install Neovim with plugins"
	@echo "  make code       - Install VS Code and extensions"
	@echo "  make python     - Install Python 3.13 with pyenv"
	@echo "  make node       - Install Node.js with nvm"
	@echo "  make docker     - Pull Docker/container images"
	@echo "  make languages  - Install Rust, Java, and SQL tools"
	@echo "  make upgrade    - Upgrade all installed packages"
	@echo "  make clean      - Clean temporary files and Docker"
	@echo "  make verify     - Verify installation status"

.PHONY: all
all: brew zsh vi code python node docker languages
	@echo "✨ Setup complete!"

.PHONY: brew
brew:
	@scripts/install-homebrew.sh

.PHONY: zsh
zsh:
	@scripts/install-zsh.sh

.PHONY: vi
vi: brew
	@scripts/install-neovim.sh

.PHONY: code
code: brew
	@scripts/install-vscode.sh

.PHONY: python
python: brew
	@scripts/install-python.sh

.PHONY: node
node: brew
	@scripts/install-node.sh

.PHONY: docker
docker: brew
	@scripts/install-docker.sh

.PHONY: languages
languages: brew
	@scripts/install-languages.sh all

.PHONY: rust
rust: brew
	@scripts/install-languages.sh rust

.PHONY: java
java: brew
	@scripts/install-languages.sh java

.PHONY: sql
sql: brew
	@scripts/install-languages.sh sql

.PHONY: upgrade
upgrade:
	@scripts/upgrade.sh

.PHONY: clean
clean:
	@scripts/clean.sh all

.PHONY: verify
verify:
	@scripts/verify.sh

.PHONY: reset-test
reset-test:
	@echo "🧹 Cleaning up for end-to-end testing..."
	@# Remove Python virtual environment
	@if [[ -d "$(PYTHON_VENV)" ]]; then rm -rf "$(PYTHON_VENV)"; echo "Removed Python venv"; fi
	@# Clean up any partial installations
	@scripts/clean.sh all
	@echo "✓ Reset complete - ready for testing"