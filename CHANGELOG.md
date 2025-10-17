# Changelog

## 2025-10-16 - Major Simplification

### Changed
- **Consolidated 13 scripts into 2**: Replaced all individual install scripts with a single `setup.sh`
- **Simplified Makefile**: Reduced from 104 lines to 56 lines
- **Streamlined README**: Removed verbose documentation, kept only essentials
- **Moved scripts to root**: `setup.sh` and `verify.sh` now live at the root level

### Removed
- `scripts/` directory (moved to `old-scripts/` for reference)
- `scripts/common.sh` - functionality moved directly into `setup.sh`
- All individual `install-*.sh` scripts
- Unnecessary abstractions and helper functions

### Benefits
- **Easier to understand**: Single file contains all installation logic
- **Easier to maintain**: No complex function abstractions
- **Easier to debug**: All logic is visible in one place
- **Faster to read**: No jumping between files to understand flow
- **Fixed Docker linking**: Added automatic `brew link docker` after installation

### Usage
```bash
# Before
make brew
make zsh
make python
# etc...

# After (same commands work, but simpler implementation)
./setup.sh all
./setup.sh brew
./verify.sh
```

All configuration files in `config/` remain unchanged.
