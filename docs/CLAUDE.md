# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS development environment setup automation repository that uses a Makefile to orchestrate modular shell scripts for installing development tools, applications, and configurations. The setup is modular, idempotent, and designed to bootstrap a complete development environment.

## Key Commands

### Setup Commands
- `make help` - Show all available commands
- `make all` - Complete setup (installs everything in proper order)
- `make brew` - Install Homebrew and all formulae/casks
- `make python` - Set up Python 3.13 with pyenv and virtual environment at ~/Developer/.venv
- `make node` - Install Node.js via nvm
- `make code` - Install VS Code and extensions
- `make vi` - Set up Neovim with plugins and configuration
- `make docker` - Pull Docker and container images
- `make languages` - Install Rust, Java, and PostgreSQL
- `make upgrade` - Update all installed packages (brew, pip, npm, gcloud)
- `make clean` - Clean up temporary files and Docker resources
- `make verify` - Verify installation status

### Testing Changes
When modifying the setup:
- Run `make verify` to check installation status
- Test individual targets before running `make all`
- The setup is idempotent - targets can be run multiple times safely
- All scripts include error handling and logging

## Architecture & Directory Structure

```
.
├── Makefile              # Main orchestration file
├── scripts/              # Modular installation scripts
│   ├── common.sh        # Shared functions and utilities
│   ├── install-*.sh     # Installation scripts for each component
│   ├── upgrade.sh       # Package upgrade script
│   ├── clean.sh         # Cleanup script
│   └── verify.sh        # Installation verification
└── config/              # Configuration files
    ├── brew-formulae.txt     # CLI tools via Homebrew
    ├── brew-casks.txt        # GUI applications via Homebrew Cask
    ├── code-extensions.txt   # VS Code extensions
    ├── python-requirements.txt # Python packages
    ├── docker-images.txt     # Docker images to pre-pull
    ├── containers.txt        # Container images
    └── node-modules.txt      # Global npm packages
```

### Script Architecture
- All scripts source `common.sh` for shared functionality
- Scripts use consistent error handling and logging
- Each script can be run independently
- Scripts check for existing installations to avoid redundancy

### External Dependencies
The setup downloads configuration files from `yoichiojima-2/dotfiles`:
- `.zshrc` - Zsh configuration
- `init.vim` - Neovim configuration

## Development Notes

- When adding new packages, append them to the appropriate file in `config/`
- Scripts are automatically made executable by the Makefile
- Virtual environment is created at `~/Developer/.venv`
- Python version is pinned to 3.13 via pyenv
- All installations use error-tolerant approaches (e.g., `--force` flags)
- Logs include timestamps and clear success/error indicators