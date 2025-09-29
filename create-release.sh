#!/bin/bash

# Create a distributable release package
# Users can download and run without Xcode

set -e

echo "📦 Creating release package..."
echo ""

# Build if needed
if [ ! -d "DirectBuild/TimestampConverter.app" ]; then
    echo "Building app first..."
    ./build-direct.sh
    echo ""
fi

# Create release directory
RELEASE_DIR="release"
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Copy app
echo "Copying app bundle..."
cp -R DirectBuild/TimestampConverter.app "$RELEASE_DIR/"

# Copy documentation
echo "Copying documentation..."
cp README.md "$RELEASE_DIR/"
cp QUICKSTART.md "$RELEASE_DIR/"
cp LICENSE "$RELEASE_DIR/"

# Create simple install script for end users
cat > "$RELEASE_DIR/INSTALL.txt" << 'EOF'
TIMESTAMP CONVERTER - INSTALLATION
===================================

EASY INSTALLATION (drag & drop):
  1. Drag TimestampConverter.app to your Applications folder
  2. Launch it from Applications or Spotlight
  3. Look for the clock icon in your menu bar
  4. Grant accessibility permissions when prompted

FIRST USE:
  1. Select any timestamp (e.g., 1737025200)
  2. Press ⌘⇧T (Command + Shift + T)
  3. Choose format to copy or insert

DOCUMENTATION:
  See README.md for complete documentation

SUPPORT:
  https://github.com/yourusername/TimestampConverter
EOF

# Create DMG-style instructions
cat > "$RELEASE_DIR/README_FIRST.txt" << 'EOF'
╔══════════════════════════════════════════════════════════╗
║                                                          ║
║         🕐  TIMESTAMP CONVERTER FOR MACOS  🕐           ║
║                                                          ║
║                    Version 1.0                           ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝

QUICK START:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. INSTALL
   → Drag "TimestampConverter.app" to Applications folder

2. LAUNCH
   → Open from Applications or Spotlight
   → Look for clock icon (🕐) in menu bar

3. GRANT PERMISSIONS
   → Click "Open System Settings" when prompted
   → Enable accessibility for TimestampConverter

4. USE IT!
   → Select any timestamp
   → Press ⌘⇧T
   → Copy or insert conversion

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FEATURES:
  ✓ Global keyboard shortcut (⌘⇧T)
  ✓ Smart format detection
  ✓ Works in any app
  ✓ Copy or direct insert
  ✓ Context menu integration
  ✓ Completely offline & private

SUPPORTED FORMATS:
  • Unix timestamps (seconds, milliseconds, μs, ns)
  • ISO 8601 dates
  • Human-readable dates
  • Relative time

For full documentation, see README.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Create archive
echo "Creating archive..."
cd "$RELEASE_DIR"
zip -r ../TimestampConverter-v1.0-macOS.zip . > /dev/null
cd ..

echo ""
echo "✅ Release package created!"
echo ""
echo "📦 Package: TimestampConverter-v1.0-macOS.zip"
echo "📁 Contents:"
ls -lh release/
echo ""
echo "📤 Ready to distribute!"
echo ""
echo "Users can:"
echo "  1. Download and unzip"
echo "  2. Drag app to Applications"
echo "  3. Launch and use"
echo ""
echo "No Xcode required! ✨"