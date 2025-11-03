# Contributing to Terminal Themes

First off, thanks for taking the time to contribute! 🎉

The following is a set of guidelines for contributing to Rory's Terminal Theme Collection. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Creating New Themes](#creating-new-themes)
  - [Pull Requests](#pull-requests)
- [Style Guidelines](#style-guidelines)
- [Theme Submission Checklist](#theme-submission-checklist)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to rodericklrenwick@gmail.com.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include your environment details:**
  - OS and version
  - Terminal emulator and version
  - Bash version
  - Theme being used

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Explain why this enhancement would be useful**
- **List any similar features in other projects, if applicable**

### Creating New Themes

We love new themes! Here's how to create one:

1. **Fork the repository**
2. **Create your theme branch** (`git checkout -b theme/your-theme-name`)
3. **Copy an existing theme as a template**
   ```bash
   cp themes/matrix-classic.sh themes/matrix-yourtheme.sh
   ```
4. **Customize your theme:**
   - Update `SYMBOLS` with relevant characters/emojis
   - Adjust `color` ranges for your color scheme
   - Create appropriate `ALERTS` messages
   - Test thoroughly!

5. **Test your theme:**
   ```bash
   chmod +x themes/matrix-yourtheme.sh
   ./themes/matrix-yourtheme.sh --init
   ./themes/matrix-yourtheme.sh
   ```

6. **Update documentation:**
   - Add your theme to README.md
   - Include color codes and description
   - Add a row to the theme showcase table

7. **Commit and push** (`git commit -m 'Add YourTheme'`)
8. **Create a Pull Request**

### Pull Requests

1. Fill in the pull request template
2. Include screenshots or GIFs demonstrating the changes
3. Follow the bash style guidelines
4. Update the documentation
5. Add your changes to CHANGELOG.md

## Style Guidelines

### Bash Script Style

- Use 4 spaces for indentation (no tabs)
- Add comments for complex logic
- Use meaningful variable names
- Follow existing function patterns
- Include error handling where appropriate

**Good Example:**
```bash
rain() {
    # Generate random column position for this rain stream
    ((symbolCol = RANDOM % COLUMNS + 1))
    ((symbolSpeed = RANDOM % 9 + 1))
    ((symbolLen = RANDOM % 9 + 2))
    
    # Draw the rain stream
    for (( i = 0; i <= LINES + symbolLen; i++ )); do
        symbol="${SYMBOLS:RANDOM % ${#SYMBOLS}:1}"
        color=$((RANDOM % 6 + 82))
        printf '\e[%d;%dH\e[38;5;%dm%s\e[0m' "$i" "$symbolCol" "$color" "$symbol"
        (( i > symbolLen )) && printf '\e[%d;%dH ' "$((i - symbolLen))" "$symbolCol"
        sleep "0.0$symbolSpeed"
    done
}
```

### Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters
- Reference issues and pull requests liberally after the first line

**Examples:**
```
Add Valentine's Day theme

- Implement pink/red color scheme
- Add heart emojis to symbol set
- Create romantic alert messages
- Update README with new theme info

Closes #42
```

### Color Guidelines

When creating themes, use 256-color ANSI codes for consistency:

```bash
# Popular color ranges:
# Greens: 40-51, 82-87, 118-123
# Reds: 88-94, 124-130, 160-167, 196-203
# Blues: 17-21, 24-27, 33-39, 69-75
# Purples: 54-57, 90-93, 126-129, 161-165
# Yellows/Golds: 136-143, 178-185, 220-227
# Oranges: 166-173, 202-209, 214-221
# Pinks: 161-168, 197-205, 213-218
```

View the full chart: https://www.ditig.com/256-colors-cheat-sheet

## Theme Submission Checklist

Before submitting a new theme, make sure:

- [ ] Script runs without errors
- [ ] Theme uses appropriate color scheme (256-color codes)
- [ ] Symbols render correctly in common terminals
- [ ] Alert messages are relevant to theme
- [ ] Both `--init` and infinite modes work
- [ ] Cleanup function restores terminal properly
- [ ] Script follows existing structure and style
- [ ] README.md updated with theme info
- [ ] Theme name is descriptive and unique
- [ ] Tested on at least 2 different terminals
- [ ] No offensive or inappropriate content
- [ ] Documentation includes:
  - [ ] Color scheme details
  - [ ] Symbol description
  - [ ] Alert messages list
  - [ ] Theme inspiration/concept

## Theme Ideas

Looking for inspiration? Here are some theme ideas:

**Holidays & Seasons:**
- 💝 Valentine's Day (pink/red hearts)
- 🍀 St. Patrick's Day (green clovers)
- 🎆 New Year's (gold/silver fireworks)
- 🦃 Thanksgiving (autumn colors)
- 🏳️‍🌈 Pride (rainbow gradient)

**Nature:**
- 🌊 Ocean (blue/teal waves)
- 🔥 Fire (red/orange flames)
- 🌙 Night Sky (purple/blue stars)
- 🌺 Tropical (vibrant island colors)
- 🍂 Autumn (orange/brown leaves)

**Tech & Culture:**
- 🤖 Robot/AI (silver/blue)
- 🎮 Retro Gaming (pixel art)
- 🌈 Vaporwave (pink/cyan aesthetic)
- 👾 Space Invaders (arcade theme)
- 🎸 Rock/Metal (dark with red accents)

**Other:**
- 🏴‍☠️ Pirate (black/gold)
- 🧛 Vampire (red/black)
- 🦄 Unicorn (pastel rainbow)
- 🐉 Dragon (fantasy theme)
- ⚡ Neon (bright electric colors)

## Testing Guidelines

Test your theme on:

- **Multiple terminals:** iTerm2, GNOME Terminal, Alacritty, Windows Terminal
- **Different screen sizes:** Ensure it works on various terminal dimensions
- **Color depth:** Verify 256-color support is working
- **Performance:** Test on older/slower systems if possible

## Questions?

Feel free to open an issue with the label "question" or contact:
- Email: rodericklrenwick@gmail.com
- GitHub: [@RLR-GitHub](https://github.com/RLR-GitHub)

## Recognition

Contributors will be acknowledged in:
- README.md Contributors section
- CHANGELOG.md for each release
- The theme file itself (as author)

Thank you for contributing! 🚀
