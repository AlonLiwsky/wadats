#!/bin/bash

# Easy installation script for Wadats
# No Xcode required!

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║            WADATS - EASY INSTALLER                      ║"
echo "║            What's that timestamp?                        ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Check if app already exists
if [ -d "DirectBuild/Wadats.app" ]; then
    echo "✅ Pre-built app found!"
    echo ""
else
    echo "📦 No pre-built app found. Building from source..."
    echo ""

    # Check if Swift is available
    if ! command -v swift &> /dev/null; then
        echo "❌ Swift compiler not found"
        echo ""
        echo "Please install Xcode Command Line Tools:"
        echo "  xcode-select --install"
        echo ""
        exit 1
    fi

    # Build the app
    ./build-direct.sh

    if [ ! -d "DirectBuild/Wadats.app" ]; then
        echo "❌ Build failed"
        exit 1
    fi
    echo ""
fi

# Install to Applications
echo "📥 Installing to /Applications..."
echo ""

if [ -d "/Applications/Wadats.app" ]; then
    echo "⚠️  Wadats is already installed"
    read -p "   Replace it? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
    rm -rf "/Applications/Wadats.app"
fi

cp -R DirectBuild/Wadats.app /Applications/

echo "✅ Installation complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 TO START USING:"
echo ""
echo "   1. Launch Wadats from Applications folder or Spotlight"
echo "   2. Look for the clock icon (🕐) in your menu bar"
echo "   3. Grant accessibility permissions when prompted"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 QUICK TEST:"
echo ""
echo "   1. Open any app (TextEdit, Safari, etc.)"
echo "   2. Type: 1737025200"
echo "   3. Select the text"
echo "   4. Press ⌘⇧T (Command + Shift + T)"
echo "   5. Use arrow keys to navigate, Enter to copy, Cmd+Enter to insert"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Opening the app now..."
echo ""

open /Applications/Wadats.app

sleep 2

echo "✅ Done! Check your menu bar for the clock icon 🕐"
echo ""