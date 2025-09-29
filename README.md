# Wadats

**What's that timestamp?**

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
📋 **One-Click Actions** - Press Enter to copy, Cmd+Enter to insert
🎯 **Multiple Formats** - Supports Unix timestamps (seconds, milliseconds, microseconds, nanoseconds), ISO 8601, and human-readable dates
🎨 **Maccy-style UI** - Clean list interface that appears at your cursor

## Supported Formats

### Input Formats
- Unix timestamps (seconds, milliseconds, microseconds, nanoseconds)
- ISO 8601 date strings (`2025-01-15T10:30:45.123Z`)
- Human-readable dates (`January 15, 2025`, `01/15/2025`, etc.)

### Output Formats
- ISO 8601 with timezone (shown first for timestamps)
- Human-readable (long and short formats)
- Relative time (e.g., "2 hours ago")
- Unix seconds/milliseconds/microseconds

## Installation

### Option 1: Easy Install (No Xcode Required!) ⭐ **Recommended**

```bash
# Clone and install
git clone https://github.com/AlonLiwsky/wadats.git
cd wadats
./install.sh
```

That's it! The app will build and install automatically. Only requires Swift compiler (comes with Command Line Tools).

### Option 2: Pre-built Release

1. Download the latest release from the [Releases](https://github.com/AlonLiwsky/wadats/releases) page
2. Unzip and drag `Wadats.app` to your Applications folder
3. Launch the app

### Option 3: Build with Xcode (For Development)

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/wadats.git
   cd wadats
   ```

2. **Build and Run**
   ```bash
   # Quick build
   ./build-direct.sh
   open DirectBuild/Wadats.app

   # Or use Xcode
   open TimestampConverter.xcodeproj
   # Press ⌘R to build and run
   ```

## First Run Setup

### Grant Accessibility Permissions

For the global keyboard shortcut and text selection features to work, you need to grant accessibility permissions:

1. Launch **Wadats**
2. When prompted, click **"Open System Settings"**
3. In **System Settings → Privacy & Security → Accessibility**:
   - Click the lock icon to make changes
   - Find **Wadats** in the list
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
3. A list appears at your cursor with conversion options
4. Use arrow keys (↑↓) to navigate or hover with mouse
5. Press **Enter** to copy, **Cmd+Enter** to insert
6. Press **Escape** to close or click outside

### Keyboard Shortcuts

- **⌘⇧T** - Open converter on selected text
- **↑↓** - Navigate through options
- **Enter** - Copy selected value to clipboard
- **Cmd+Enter** - Insert selected value into active app
- **Escape** - Close popup
- **Click outside** - Close popup

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

**Output (in order shown):**
1. **ISO 8601:** `2025-01-16T10:00:00.000Z`
2. **Human Readable:** `January 16, 2025 at 10:00:00 AM UTC`
3. **Short Format:** `1/16/25, 10:00 AM`
4. **Relative:** `17 days from now`
5. Milliseconds: `1737025200000`
6. Microseconds: `1737025200000000`

### Converting Date to Unix Timestamp

**Input:** `January 16, 2025`

**Output:**
- **ISO 8601:** `2025-01-16T00:00:00.000Z`
- **Human Readable:** `January 16, 2025 at 12:00:00 AM UTC`
- **Unix Seconds:** `1736985600`
- **Unix Milliseconds:** `1736985600000`

## Project Structure

```
wadats/
├── TimestampConverter.xcodeproj/      # Xcode project file
├── TimestampConverter/
│   ├── Core/                          # Core logic
│   │   ├── TimestampConverter.swift   # Conversion engine
│   │   ├── ConversionResult.swift     # Data models
│   │   └── GlobalHotKeyManager.swift  # Keyboard shortcut handler
│   ├── UI/                            # User interface
│   │   ├── PopupWindow.swift          # Main popup window (Maccy-style)
│   │   └── SettingsView.swift         # Settings/about window
│   ├── AppDelegate.swift              # App lifecycle & menu bar
│   ├── WadatsApp.swift                # App entry point
│   ├── Info.plist                     # App configuration
│   ├── TimestampConverter.entitlements # Security permissions
│   └── Assets.xcassets/               # App icons and assets
└── README.md                          # This file
```

## Development

### Requirements

- macOS 12.0 or later
- Xcode 14.0 or later (for Xcode-based builds)
- Swift 5.0 or later (comes with Command Line Tools)

### Building

```bash
# Clone the repository
git clone https://github.com/yourusername/wadats.git
cd wadats

# Build without Xcode IDE
./build-direct.sh
open DirectBuild/Wadats.app

# Or open in Xcode
open TimestampConverter.xcodeproj
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

### Arrow Keys Not Working

- Make sure the popup window has focus (it should automatically)
- Try clicking on the popup window first
- Check Accessibility permissions

### Context Menu Not Appearing

- Services can take time to register with macOS
- Try logging out and back in
- Check System Settings → Keyboard → Keyboard Shortcuts → Services

### App Not Detecting Timestamps

- Ensure the text is properly selected
- Try different selection methods (double-click, triple-click, manual selection)
- Verify the timestamp format is supported

### Popup Not Closing

- Press Escape
- Click anywhere outside the popup
- The popup should auto-close when you take any action

## Uninstalling

1. Quit the app (right-click menu bar icon → Quit)
2. Delete from Applications folder:
   ```bash
   rm -rf /Applications/Wadats.app
   ```
3. Remove accessibility permissions (optional):
   - System Settings → Privacy & Security → Accessibility
   - Remove Wadats from the list

## Privacy

Wadats:
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

Inspired by [Maccy](https://maccy.app/) and [Clipy](https://github.com/Clipy/Clipy) - excellent clipboard managers for macOS.

## Support

- 🐛 [Report a bug](https://github.com/AlonLiwsky/wadats/issues)
- 💡 [Request a feature](https://github.com/AlonLiwsky/wadats/issues)
- 📖 [View documentation](https://github.com/AlonLiwsky/wadats/wiki)

---

<div align="center">
Made with ❤️ for developers who work with timestamps
<br>
<strong>Wadats - What's that timestamp?</strong>
</div>
