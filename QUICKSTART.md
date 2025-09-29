# Quick Start Guide

Get Timestamp Converter up and running in 5 minutes!

## Step 1: Build the App

If you don't have Xcode installed, download it from the [Mac App Store](https://apps.apple.com/app/xcode/id497799835).

### Option A: Build with Xcode (Easiest)

1. Open the project:
   ```bash
   open TimestampConverter.xcodeproj
   ```

2. In Xcode:
   - Press `⌘R` to build and run
   - The app will launch automatically

### Option B: Build with Script

1. Make sure Xcode is properly configured:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```

2. Run the build script:
   ```bash
   ./build.sh
   ```

3. Install to Applications:
   ```bash
   cp -R ./build/Build/Products/Release/TimestampConverter.app /Applications/
   ```

4. Launch the app:
   ```bash
   open /Applications/TimestampConverter.app
   ```

## Step 2: Grant Permissions

When you first launch the app, you'll be prompted to grant accessibility permissions:

1. Click **"Open System Settings"** in the alert
2. In **System Settings → Privacy & Security → Accessibility**:
   - Click the lock 🔒 to make changes
   - Find **TimestampConverter** and toggle it **ON**
3. Close System Settings and restart the app if needed

**Why?** These permissions allow the app to read selected text and simulate keyboard input.

## Step 3: Try It Out!

### Quick Test

1. Open any text editor or browser
2. Select this timestamp: `1737025200`
3. Press `⌘⇧T` (Command + Shift + T)
4. A popup appears showing:
   - ISO 8601 date
   - Human readable format
   - Relative time
   - And more!

### Test Conversions

Try converting these examples:

| Input | Type | Press ⌘⇧T |
|-------|------|-----------|
| `1737025200` | Unix seconds | → ISO 8601, human date |
| `1737025200000` | Unix milliseconds | → Seconds, ISO 8601 |
| `2025-01-15T10:00:00Z` | ISO 8601 | → Unix timestamp |
| `January 15, 2025` | Human date | → All formats |

## Step 4: Use It Everywhere

### Method 1: Keyboard Shortcut (Fastest)
- Select any timestamp
- Press `⌘⇧T`
- Click to copy or insert

### Method 2: Menu Bar
- Click the 🕐 icon in your menu bar
- Select "Convert Selected Text"

### Method 3: Right-Click Menu
- Select text
- Right-click → **Services** → **Convert Timestamp**

## Tips & Tricks

### Copy vs Insert

- **Copy icon** 📄: Copies to clipboard
- **Insert icon** ⬇️: Pastes directly into your app

### Supported Formats

The app automatically detects:
- Unix timestamps (seconds, milliseconds, microseconds, nanoseconds)
- ISO 8601 dates
- Common date formats (MM/DD/YYYY, DD/MM/YYYY, etc.)

### Check Your Menu Bar

Look for the clock icon in your menu bar (top-right). If you don't see it:
- The app might not be running
- Check Activity Monitor for "TimestampConverter"
- Try relaunching the app

## Troubleshooting

### "Keyboard shortcut doesn't work"
→ Grant accessibility permissions (see Step 2)

### "Menu bar icon missing"
→ Restart the app or check if macOS is hiding it

### "No conversion results"
→ Make sure text is selected and is a valid timestamp

### "Context menu doesn't show"
→ Log out and back in, or restart your Mac

## Next Steps

- **Customize**: Open Settings from the menu bar
- **Learn More**: Read the full [README.md](README.md)
- **Contribute**: Check out [CONTRIBUTING.md](CONTRIBUTING.md)

## Need Help?

- [Report a bug](https://github.com/yourusername/TimestampConverter/issues)
- [Read the FAQ](https://github.com/yourusername/TimestampConverter/wiki)
- Check the full README for detailed documentation

---

**That's it! You're ready to convert timestamps like a pro.** 🚀