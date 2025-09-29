# Timestamp Converter

<div align="center">

![macOS](https://img.shields.io/badge/macOS-12.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A lightweight, always-accessible macOS menu bar app for converting timestamps between various formats.

</div>

## Features

✨ **Always Accessible** - Lives in your menu bar, accessible from any app
⌨️ **Global Keyboard Shortcut** - Press `⌘⇧T` to convert selected timestamps instantly
🖱️ **Context Menu Integration** - Right-click selected text → Services → Convert Timestamp
🔄 **Smart Detection** - Automatically detects timestamp format and offers relevant conversions
📋 **One-Click Actions** - Copy to clipboard or insert directly into active application
🎯 **Multiple Formats** - Supports Unix timestamps (seconds, milliseconds, microseconds, nanoseconds), ISO 8601, and human-readable dates

## Supported Formats

### Input Formats
- Unix timestamps (seconds, milliseconds, microseconds, nanoseconds)
- ISO 8601 date strings (`2025-01-15T10:30:45.123Z`)
- Human-readable dates (`January 15, 2025`, `01/15/2025`, etc.)

### Output Formats
- Unix seconds/milliseconds/microseconds
- ISO 8601 with timezone
- Human-readable (long and short formats)
- Relative time (e.g., "2 hours ago")

## Installation

### Option 1: Build from Source (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/TimestampConverter.git
   cd TimestampConverter
   ```

2. **Open in Xcode**
   ```bash
   open TimestampConverter.xcodeproj
   ```

3. **Build and Run**
   - Select the `TimestampConverter` scheme
   - Press `⌘R` to build and run
   - Or press `⌘B` to build, then find the app in `DerivedData`

4. **Move to Applications** (Optional)
   ```bash
   # After building, copy to Applications folder
   cp -R ~/Library/Developer/Xcode/DerivedData/TimestampConverter-*/Build/Products/Debug/TimestampConverter.app /Applications/
   ```

### Option 2: Pre-built Release

1. Download the latest release from the [Releases](https://github.com/yourusername/TimestampConverter/releases) page
2. Unzip and drag `TimestampConverter.app` to your Applications folder
3. Launch the app

## First Run Setup

### Grant Accessibility Permissions

For the global keyboard shortcut and text selection features to work, you need to grant accessibility permissions:

1. Launch **TimestampConverter**
2. When prompted, click **"Open System Settings"**
3. In **System Settings → Privacy & Security → Accessibility**:
   - Click the lock icon to make changes
   - Find **TimestampConverter** in the list
   - Toggle it **ON**
4. Restart the app if needed

### Enable Services (Optional)

For context menu integration:

1. Go to **System Settings → Keyboard → Keyboard Shortcuts → Services**
2. Find **"Convert Timestamp"** under "Text"
3. Enable it and optionally assign a custom keyboard shortcut

## Usage

### Method 1: Global Keyboard Shortcut (Recommended)

1. Select any timestamp text in any application
2. Press `⌘⇧T` (Command + Shift + T)
3. A popup window appears with conversion options
4. Click any result to copy, or click the insert button to paste it directly

### Method 2: Context Menu

1. Select timestamp text
2. Right-click → **Services** → **Convert Timestamp**
3. Choose from the conversion options in the popup

### Method 3: Menu Bar

1. Click the clock icon in your menu bar
2. Select **"Convert Selected Text"**
3. (Make sure you have text selected first)

## Examples

### Converting Unix Timestamp to Date

**Input:** `1737025200`

**Output:**
- **ISO 8601:** `2025-01-15T10:00:00.000Z`
- **Human Readable:** `January 15, 2025 at 10:00:00 AM UTC`
- **Relative:** `2 days ago`

### Converting Date to Unix Timestamp

**Input:** `January 15, 2025`

**Output:**
- **Unix Seconds:** `1737025200`
- **Unix Milliseconds:** `1737025200000`
- **ISO 8601:** `2025-01-15T10:00:00.000Z`

### Converting Between Precisions

**Input:** `1737025200000` (milliseconds)

**Output:**
- **Seconds:** `1737025200`
- **Microseconds:** `1737025200000000`
- **Human Readable:** `January 15, 2025 at 10:00:00 AM UTC`

## Project Structure

```
TimestampConverter/
├── TimestampConverter.xcodeproj/      # Xcode project file
├── TimestampConverter/
│   ├── Core/                          # Core logic
│   │   ├── TimestampConverter.swift   # Conversion engine
│   │   ├── ConversionResult.swift     # Data models
│   │   └── GlobalHotKeyManager.swift  # Keyboard shortcut handler
│   ├── UI/                            # User interface
│   │   ├── PopupWindow.swift          # Main popup window
│   │   └── SettingsView.swift         # Settings/about window
│   ├── AppDelegate.swift              # App lifecycle & menu bar
│   ├── TimestampConverterApp.swift    # App entry point
│   ├── Info.plist                     # App configuration
│   ├── TimestampConverter.entitlements # Security permissions
│   └── Assets.xcassets/               # App icons and assets
└── README.md                          # This file
```

## Development

### Requirements

- macOS 12.0 or later
- Xcode 14.0 or later
- Swift 5.0 or later

### Building

```bash
# Clone the repository
git clone https://github.com/yourusername/TimestampConverter.git
cd TimestampConverter

# Open in Xcode
open TimestampConverter.xcodeproj

# Or build from command line
xcodebuild -project TimestampConverter.xcodeproj -scheme TimestampConverter -configuration Release build
```

### Extending the App

The codebase is organized for easy extension:

- **Add new timestamp formats**: Extend `TimestampConverter.swift`
- **Customize UI**: Modify `PopupWindow.swift` and `SettingsView.swift`
- **Change keyboard shortcut**: Update `GlobalHotKeyManager.swift`
- **Add new features**: Follow the existing pattern in the `Core/` and `UI/` directories

## Troubleshooting

### Global Shortcut Not Working

- Ensure Accessibility permissions are granted (see [First Run Setup](#first-run-setup))
- Check if another app is using the same shortcut (`⌘⇧T`)
- Restart the app after granting permissions

### Context Menu Not Appearing

- Services can take time to register with macOS
- Try logging out and back in
- Check System Settings → Keyboard → Keyboard Shortcuts → Services

### App Not Detecting Timestamps

- Ensure the text is properly selected
- Try different selection methods (double-click, triple-click, manual selection)
- Verify the timestamp format is supported

### Menu Bar Icon Missing

- Check if the app is running (look in Activity Monitor)
- Try quitting and relaunching the app
- Ensure you're running macOS 12.0 or later

## Uninstalling

1. Quit the app (right-click menu bar icon → Quit)
2. Delete from Applications folder:
   ```bash
   rm -rf /Applications/TimestampConverter.app
   ```
3. Remove accessibility permissions (optional):
   - System Settings → Privacy & Security → Accessibility
   - Remove TimestampConverter from the list

## Privacy

TimestampConverter:
- ✅ Runs completely offline (no network access)
- ✅ Does not collect or transmit any data
- ✅ Only accesses selected text when you trigger conversion
- ✅ Uses accessibility APIs solely for reading selected text
- ✅ Open source - audit the code yourself

## License

MIT License - feel free to use, modify, and distribute.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Acknowledgments

Inspired by [Maccy](https://maccy.app/) - the excellent clipboard manager for macOS.

## Support

- 🐛 [Report a bug](https://github.com/yourusername/TimestampConverter/issues)
- 💡 [Request a feature](https://github.com/yourusername/TimestampConverter/issues)
- 📖 [View documentation](https://github.com/yourusername/TimestampConverter/wiki)

---

<div align="center">
Made with ❤️ for developers who work with timestamps
</div>