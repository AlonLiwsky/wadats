# Contributing to Wadats

Thank you for your interest in contributing to Wadats (What's that timestamp?)! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/wadats.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Test thoroughly
6. Commit your changes: `git commit -m 'Add amazing feature'`
7. Push to your fork: `git push origin feature/amazing-feature`
8. Open a Pull Request

## Development Setup

### Requirements

- macOS 12.0 or later
- Swift 5.0 or later (comes with Command Line Tools)
- Xcode (optional, only for IDE development)

### Building the Project

```bash
# Easy build (no Xcode IDE required)
./build-direct.sh

# Install to Applications
./install.sh

# Or open in Xcode (if you have it)
open TimestampConverter.xcodeproj
```

## Code Style

- Follow Swift API Design Guidelines
- Use 4 spaces for indentation (no tabs)
- Maximum line length: 120 characters
- Use meaningful variable and function names
- Add comments for complex logic
- Group related code with `// MARK:` comments

## Project Structure

```
TimestampConverter/
├── Core/           # Business logic and data models
├── UI/             # User interface components
├── AppDelegate     # App lifecycle and menu bar
└── Resources/      # Assets, plists, etc.
```

## Adding New Features

### Adding a New Timestamp Format

1. Update `TimestampConverter.swift`:
   - Add detection logic in `detectInputType()`
   - Add conversion method (e.g., `convertFromNewFormat()`)
   - Add corresponding `DetectedInputType` case

2. Test with various inputs

### Modifying the UI

1. Update SwiftUI views in `UI/` folder
2. Follow existing design patterns
3. Ensure dark mode compatibility
4. Test on different screen sizes

## Testing

### Manual Testing Checklist

- [ ] Global keyboard shortcut works (`⌘⇧T`)
- [ ] Menu bar icon appears and menu works
- [ ] Context menu service works
- [ ] All timestamp formats convert correctly
- [ ] Copy to clipboard works
- [ ] Insert text works
- [ ] Settings window displays correctly
- [ ] App requests accessibility permissions
- [ ] App works in dark mode
- [ ] No memory leaks

### Test Cases to Consider

1. Unix timestamps (seconds, milliseconds, microseconds, nanoseconds)
2. ISO 8601 dates with/without fractional seconds
3. Various human-readable date formats
4. Edge cases (year 1970, far future dates, invalid inputs)
5. Empty/whitespace-only selections
6. Very long strings

## Pull Request Guidelines

### Before Submitting

- [ ] Code builds without errors or warnings
- [ ] All features work as expected
- [ ] Code follows project style guidelines
- [ ] No debugging code (print statements, etc.)
- [ ] README updated if needed
- [ ] No merge conflicts with main branch

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe how you tested your changes

## Screenshots (if applicable)
Add screenshots to help explain your changes

## Checklist
- [ ] Code follows project style
- [ ] Self-review completed
- [ ] Tested on macOS 12+
- [ ] No warnings or errors
```

## Reporting Bugs

### Bug Report Template

```markdown
**Description**
A clear description of the bug

**Steps to Reproduce**
1. Step one
2. Step two
3. ...

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- macOS version:
- App version:
- Xcode version (if building from source):

**Screenshots**
If applicable, add screenshots

**Additional Context**
Any other relevant information
```

## Feature Requests

We welcome feature requests! Please:

1. Check if the feature already exists or is planned
2. Describe the feature and its benefits
3. Provide use cases
4. Consider implementation complexity

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Assume good intentions

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Publishing others' private information
- Other unprofessional conduct

## Questions?

Feel free to open an issue with the `question` label or reach out to the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Wadats! 🎉