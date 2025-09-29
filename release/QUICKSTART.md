# Quick Start Guide

Get Wadats (What's that timestamp?) up and running in 5 minutes!

## Step 1: Install the App

### Easy Install (No Xcode Required!) ⭐ Recommended

```bash
./install.sh
```

That's it! The script will:
- Build the app using Swift compiler (already on your Mac)
- Install it to /Applications
- Launch it automatically

### Alternative: Manual Build

If you prefer to build manually:

```bash
# Build the app
./build-direct.sh

# Install to Applications
cp -R DirectBuild/Wadats.app /Applications/

# Launch
open /Applications/Wadats.app
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
4. A Maccy-style popup appears at your cursor showing:
   - ISO 8601 date
   - Human readable format
   - Relative time
   - And more!
5. Use arrow keys (↑↓) to navigate or hover with mouse
6. Press **Enter** to copy, **Cmd+Enter** to insert
7. Press **ESC** to close or click outside

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
- Use arrow keys (↑↓) to navigate
- Press **Enter** to copy, **Cmd+Enter** to insert
- Press **ESC** to close or click outside

### Method 2: Menu Bar
- Click the 🕐 icon in your menu bar
- Select "Convert Selected Text"

### Method 3: Right-Click Menu
- Select text
- Right-click → **Services** → **Convert Timestamp**

## Tips & Tricks

### Keyboard Shortcuts

- **⌘⇧T** - Open converter on selected text
- **↑↓** - Navigate through options
- **Enter** - Copy selected value to clipboard
- **Cmd+Enter** - Insert selected value into active app
- **Escape** - Close popup
- **Click outside** - Close popup

### Supported Formats

The app automatically detects:
- Unix timestamps (seconds, milliseconds, microseconds, nanoseconds)
- ISO 8601 dates
- Common date formats (MM/DD/YYYY, DD/MM/YYYY, etc.)

### Check Your Menu Bar

Look for the clock icon in your menu bar (top-right). If you don't see it:
- The app might not be running
- Check Activity Monitor for "Wadats"
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

- [Report a bug](https://github.com/yourusername/wadats/issues)
- [Read the FAQ](https://github.com/yourusername/wadats/wiki)
- Check the full README for detailed documentation

---

**That's it! You're ready to convert timestamps like a pro.** 🚀