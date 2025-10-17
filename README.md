# macOS Setup

Automated macOS development environment setup.

## Quick Start

```bash
# Clone and run
git clone <repo-url> ~/Developer/repo/macos-setup
cd ~/Developer/repo/macos-setup

# Complete setup
./setup.sh all

# Or use make
make all
```

## Components

- **Homebrew**: Package manager and applications
- **Shell**: Zsh with Oh My Zsh
- **Editors**: Neovim, VS Code with extensions
- **Languages**: Python, Node.js
- **Containers**: Docker with pre-pulled images

## Usage

```bash
# Install everything
./setup.sh all

# Install specific components
./setup.sh xcode    # Check/install Xcode Command Line Tools
./setup.sh brew
./setup.sh zsh
./setup.sh vi
./setup.sh code
./setup.sh python
./setup.sh node
./setup.sh docker

# Verify installation
./verify.sh
```

## Configuration

Edit files in `config/` to customize:
- `brew-formulae.txt` - Homebrew packages
- `brew-casks.txt` - Homebrew applications
- `code-extensions.txt` - VS Code extensions
- `python-requirements.txt` - Python packages
- `node-modules.txt` - Global npm packages
- `docker-images.txt` - Docker images to pull
- `settings.sh` - Environment variables

This setup uses dotfiles from `~/Developer/repo/dotfiles` for shell and editor configs.