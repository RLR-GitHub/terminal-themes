# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2024-11-02

### Added
- 🎃 Halloween theme with spooky orange/black color scheme
- 🎄 Christmas theme with festive red/green colors
- 🐰 Easter theme with pastel rainbow colors
- 💻 Hacker theme with bright green cyberpunk aesthetic
- 🟢 Matrix theme with classic Matrix green
- 🌐 Interactive HTML demo page showcasing all themes
- 📦 Automated installation script with theme selection wizard
- 🔧 System status command (`sys-status`)
- 🎯 Hacker-themed aliases (hack, scan, gitc)
- 📚 Comprehensive documentation (README, QUICKSTART, CONTRIBUTING)
- 🎨 Custom cyberpunk terminal prompt
- ⚡ Quick install one-liner
- 🔄 Uninstall functionality in installer
- 🎭 Support for both bash and zsh shells
- 📜 MIT License
- 🤝 Contributing guidelines
- 📊 Repository badges and stats

### Changed
- Improved animation performance with optimized sleep timings
- Enhanced cleanup function for better terminal restoration
- Updated ANSI color codes to use full 256-color palette
- Restructured repository for better organization

### Technical Details
- Uses alternate screen buffer (`\e[?1049h`) for clean animation
- Implements proper signal handling (SIGINT, SIGTERM)
- 256-color ANSI escape sequences for rich colors
- UTF-8 support for emoji and katakana characters
- Configurable alert frequency and animation speed

## [2.0.0] - 2024-10-15

### Added
- Initial multi-theme support
- Custom symbol sets for different themes
- Alert message system with random flashing
- Two modes: `--init` (5 seconds) and infinite mode
- Katakana character support

### Changed
- Refactored core animation engine
- Improved random symbol selection
- Better terminal dimension detection

### Fixed
- Screen buffer restoration issues
- Cursor visibility problems on exit
- Race conditions in background processes

## [1.0.0] - 2024-09-01

### Added
- Initial release
- Basic Matrix rain animation
- Green color scheme
- Simple installation instructions
- Basic README documentation

### Features
- Pure bash implementation
- No external dependencies
- Falling character animation
- Random speed variation

## [Unreleased]

### Fixed
- Fixed GitHub Actions `test-install.yml` workflow matrix reference errors
- Fixed impossible job dependency constraints in workflow
- Added proper error handling for missing artifacts
- Integrated package uninstall testing into installation tests
- Improved Windows package testing with proper MSI uninstall

### Changed
- Test script installation jobs now only run on `workflow_dispatch` and `pull_request` events
- Native package testing jobs now only run on `workflow_run` events
- Removed redundant conditions in workflow steps
- Consolidated install/uninstall testing into single jobs per platform

### Planned Features
- [ ] Additional holiday themes (Valentine's, St. Patrick's, etc.)
- [ ] Configuration file support (~/.matrixrc)
- [ ] Theme switcher command
- [ ] Package manager support (Homebrew, apt)
- [ ] Windows native PowerShell version
- [ ] Color customization wizard
- [ ] Performance mode for slower systems
- [ ] Sound effects option
- [ ] Multi-language symbol sets
- [ ] Terminal recording integration
- [ ] Web-based theme builder
- [ ] Plugin system for custom effects

### Known Issues
- Emoji rendering may vary by terminal emulator
- Performance may degrade on very large terminals (>300 columns)
- Some terminals may not support all 256 colors
- Minimal WSL1 support (WSL2 recommended)

### Future Enhancements
- Gradient color transitions
- Multiple simultaneous rain streams
- Configurable symbol density
- Frame rate optimization
- Terminal size change handling
- Theme auto-switching based on date/time
- Integration with popular terminal frameworks (oh-my-zsh, oh-my-bash)

---

## Release Notes Format

Each release includes:
- **Version number** (Semantic Versioning)
- **Release date**
- **Added**: New features
- **Changed**: Changes in existing functionality  
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

---

## Version History Summary

| Version | Date | Description |
|---------|------|-------------|
| 3.0.0 | 2024-11-02 | Full theme collection with 5 themes + installer |
| 2.0.0 | 2024-10-15 | Multi-theme support and alert system |
| 1.0.0 | 2024-09-01 | Initial Matrix rain implementation |

---

## Upgrade Guide

### From 2.0 to 3.0

1. Backup your current configuration:
   ```bash
   cp ~/matrix.sh ~/matrix.sh.backup
   cp ~/.bashrc ~/.bashrc.backup
   ```

2. Install new version:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/install.sh | bash
   ```

3. Migration is automatic - installer handles shell configuration

### From 1.0 to 3.0

Significant changes require clean installation:

1. Remove old script:
   ```bash
   rm ~/matrix.sh
   ```

2. Clean old configuration from shell config

3. Run new installer:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/RLR-GitHub/terminal-themes/main/install.sh | bash
   ```

---

## Contributors

Special thanks to all contributors who have helped with:
- 🐛 Bug reports and fixes
- 💡 Feature suggestions
- 🎨 Theme designs
- 📚 Documentation improvements
- 🧪 Testing and feedback

See the full list of [contributors](https://github.com/RLR-GitHub/terminal-themes/graphs/contributors).

---

## Support

For questions or issues with specific versions:
- [Open an Issue](https://github.com/RLR-GitHub/terminal-themes/issues)
- [Email Support](mailto:rodericklrenwick@gmail.com)
- [Discussion Forum](https://github.com/RLR-GitHub/terminal-themes/discussions)

---

**Thank you for using Rory's Terminal Themes!** 🚀
