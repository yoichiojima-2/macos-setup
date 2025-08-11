# macOS Setup

Automated macOS development environment setup.

## Purpose

Bootstrap a complete macOS development environment with a single command.

## Quick Start

```bash
# Clone this repository
git clone <repo-url> ~/Developer/repo/macos-setup

# Run complete setup
make all

# Or run individual components
make brew
make zsh
make python
make docker
```

## Components

- **Homebrew**: Package manager and applications
- **Shell**: Zsh with Oh My Zsh
- **Editors**: Neovim, VS Code with extensions
- **Languages**: Python, Node.js, Rust, Java
- **Containers**: Docker with pre-pulled images
- **Tools**: CLI utilities, cloud SDKs, AI tools

## Configuration Files

This repository uses configuration files from the local `dotfiles` repository:
- Shell config: `~/Developer/repo/dotfiles/zshrc`
- Neovim config: `~/Developer/repo/dotfiles/init.vim`

## Available Make Targets

- `make all` - Complete setup
- `make brew` - Install Homebrew and packages
- `make zsh` - Configure shell
- `make vi` - Setup Neovim
- `make code` - Install VS Code and extensions
- `make python` - Setup Python environment
- `make node` - Install Node.js
- `make docker` - Setup Docker
- `make languages` - Install additional languages
- `make upgrade` - Update all packages
- `make verify` - Check installation status
- `make clean` - Clean temporary files

## Philosophy

This repository handles macOS-specific system setup and application installation.
Configuration files are managed separately in the `dotfiles` repository.