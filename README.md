# macOS Development Environment Setup

A comprehensive, automated setup for macOS development environments. This repository provides modular scripts to install and configure development tools, programming languages, editors, and applications.

## Features

- **Modular Design**: Each component can be installed independently
- **Idempotent**: Safe to run multiple times
- **Error Handling**: Comprehensive logging and error reporting
- **Easy Maintenance**: Configuration files separate from scripts
- **Verification**: Built-in verification to check installation status

## Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd macos-setup

# Run complete setup
make all

# Or see available commands
make help
```

## What Gets Installed

### Base Tools
- Homebrew package manager
- Oh My Zsh with custom configuration
- Modern CLI tools (bat, eza, fd, ripgrep, etc.)

### Development Environments
- **Python 3.13** via pyenv with virtual environment
- **Node.js** via nvm
- **Rust** via rustup
- **Java** (OpenJDK) and Hadoop
- **PostgreSQL**

### Editors & IDEs
- Neovim with plugins
- Visual Studio Code with extensions
- Cursor

### Container & Cloud Tools
- Docker Desktop
- Google Cloud SDK
- GitHub CLI

### Applications
- Browsers (Chrome, Firefox)
- Communication (Slack, Discord, Zoom)
- Development tools (Postman, TablePlus)
- Music production software
- And many more...

## Usage

### Individual Components

```bash
make brew       # Install Homebrew and packages
make python     # Set up Python environment
make node       # Install Node.js
make code       # Install VS Code with extensions
make vi         # Set up Neovim
make docker     # Pull Docker images
make languages  # Install Rust, Java, SQL
```

### Maintenance

```bash
make upgrade    # Update all packages
make clean      # Clean temporary files and Docker
make verify     # Check installation status
```

## Customization

### Adding Packages

1. Edit the appropriate file in `config/`:
   - `brew-formulae.txt` - CLI tools
   - `brew-casks.txt` - GUI applications
   - `python-requirements.txt` - Python packages
   - `code-extensions.txt` - VS Code extensions
   - etc.

2. Run the relevant make command to install

### Python Virtual Environment

The Python virtual environment is created at `~/Developer/.venv` and is automatically activated in the shell configuration.

## Requirements

- macOS (tested on macOS 12+)
- Internet connection
- Administrator access (for some installations)

## License

This project is open source and available under the MIT License.