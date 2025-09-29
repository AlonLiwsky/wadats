#!/bin/bash

# Easy installation script for TimestampConverter
# No Xcode required!

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║         TIMESTAMP CONVERTER - EASY INSTALLER            ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Check if app already exists
if [ -d "DirectBuild/TimestampConverter.app" ]; then
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

    if [ ! -d "DirectBuild/TimestampConverter.app" ]; then
        echo "❌ Build failed"
        exit 1
    fi
    echo ""
fi

# Install to Applications
echo "📥 Installing to /Applications..."
echo ""

if [ -d "/Applications/TimestampConverter.app" ]; then
    echo "⚠️  TimestampConverter is already installed"
    read -p "   Replace it? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
    rm -rf "/Applications/TimestampConverter.app"
fi

cp -R DirectBuild/TimestampConverter.app /Applications/

echo "✅ Installation complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 TO START USING:"
echo ""
echo "   1. Launch from Applications folder or Spotlight"
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
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Opening the app now..."
echo ""

open /Applications/TimestampConverter.app

sleep 2

echo "✅ Done! Check your menu bar for the clock icon 🕐"
echo ""