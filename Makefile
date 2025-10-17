# macOS Development Environment Setup
# Usage: make [target]

SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "macOS Development Environment Setup"
	@echo ""
	@echo "Usage:"
	@echo "  make all      - Complete setup (installs everything)"
	@echo "  make brew     - Install Homebrew and packages"
	@echo "  make zsh      - Install Oh My Zsh and custom config"
	@echo "  make vi       - Install Neovim with plugins"
	@echo "  make code     - Install VS Code and extensions"
	@echo "  make python   - Install Python 3.13 with pyenv"
	@echo "  make node     - Install Node.js with nvm"
	@echo "  make docker   - Pull Docker/container images"
	@echo "  make verify   - Verify installation status"

.PHONY: all
all:
	@./setup.sh all

.PHONY: brew
brew:
	@./setup.sh brew

.PHONY: zsh
zsh:
	@./setup.sh zsh

.PHONY: vi
vi:
	@./setup.sh vi

.PHONY: code
code:
	@./setup.sh code

.PHONY: python
python:
	@./setup.sh python

.PHONY: node
node:
	@./setup.sh node

.PHONY: docker
docker:
	@./setup.sh docker

.PHONY: verify
verify:
	@./verify.sh
