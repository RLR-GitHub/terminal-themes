# Option 2: PTY Shim with Color Injection

This module provides advanced terminal output styling through pseudoterminal (PTY) interception. It allows injecting custom colors and styling into any command's output without modifying the commands themselves.

## Components

### 1. `pty-wrapper.c`
A C program that creates a pseudoterminal and intercepts I/O between commands and the terminal. It applies color injection rules in real-time.

**Compile:**
```bash
make
```

**Usage:**
```bash
./pty-wrapper <command> [args...]
```

**Example:**
```bash
./pty-wrapper ls -la
./pty-wrapper git status
```

### 2. `color-rules.json`
JSON configuration file defining color injection patterns:
- Error/warning/success keywords
- File paths and URLs
- Git-specific patterns
- Command-specific rules

### 3. `command-hooks.sh`
Bash/Zsh hooks that execute before and after commands:
- Pre-command display
- Exit code status
- Command duration tracking
- Git status indicator

**Usage in `.bashrc` or `.zshrc`:**
```bash
source /path/to/command-hooks.sh
```

### 4. `output-parser.sh`
Specialized parser for command-specific output styling:
- `ls` output (directories, executables, hidden files)
- `git` output (status, log, diff)
- `grep` output (pattern highlighting)

**Usage:**
```bash
ls -la | output-parser.sh ls
git status | output-parser.sh git-status
git log | output-parser.sh git-log
```

## Installation

### System-wide Installation
```bash
make install
```

This installs:
- `/usr/local/bin/pty-wrapper`
- `/usr/local/bin/rory-terminal-hooks`
- `/usr/local/bin/rory-terminal-parser`
- `/usr/local/etc/rory-terminal/color-rules.json`

### User Installation
```bash
# Copy files to user directory
mkdir -p ~/.local/bin
make
cp pty-wrapper ~/.local/bin/
cp command-hooks.sh ~/.local/bin/rory-terminal-hooks
cp output-parser.sh ~/.local/bin/rory-terminal-parser

# Add to shell config
echo 'source ~/.local/bin/rory-terminal-hooks' >> ~/.bashrc
```

## Configuration

### Set Active Theme
```bash
export RORY_THEME=hacker
```

Available themes: `halloween`, `christmas`, `easter`, `hacker`, `matrix`

### Custom Color Rules
Edit `color-rules.json` to add custom patterns:
```json
{
  "rules": [
    {
      "name": "custom_pattern",
      "pattern": "\\b(mypattern)\\b",
      "color_type": "primary_color",
      "bold": true
    }
  ]
}
```

## Advanced Usage

### Wrapper Aliases
Add to `.bashrc`/`.zshrc` to automatically wrap commands:
```bash
alias ls='pty-wrapper ls'
alias git='pty-wrapper git'
alias grep='pty-wrapper grep'
```

### Piping Through Parser
```bash
# Use parser for specific commands
ls -la | rory-terminal-parser ls
git status | rory-terminal-parser git-status
```

### Disable Hooks Temporarily
```bash
HOOKS_ENABLED=false
```

## Platform Support

- **Linux**: Requires `libutil` (usually pre-installed)
- **macOS**: Uses built-in `util.h`
- **Windows**: Not supported (use PowerShell themes instead)

## Performance Considerations

The PTY wrapper adds minimal overhead (~1-2ms per command). For better performance:
1. Use command-specific parsers instead of generic wrapper
2. Limit pattern matching to essential keywords
3. Disable hooks for non-interactive scripts

## Troubleshooting

### Compilation Errors
```bash
# Install development tools
# Ubuntu/Debian:
sudo apt install build-essential

# macOS (install Xcode Command Line Tools):
xcode-select --install
```

### TTY Issues
If you see "not a tty" errors:
```bash
# Run with explicit TTY allocation
script -q /dev/null pty-wrapper <command>
```

### Color Not Working
Ensure terminal supports ANSI colors:
```bash
echo $TERM  # Should be xterm-256color or similar
```

## Uninstallation

```bash
make uninstall
```

Or manually remove:
- `/usr/local/bin/pty-wrapper`
- `/usr/local/bin/rory-terminal-hooks`
- `/usr/local/bin/rory-terminal-parser`
- `/usr/local/etc/rory-terminal/`

