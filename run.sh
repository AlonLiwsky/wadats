#!/bin/bash

# Quick run script for Timestamp Converter
# Builds and launches the app

set -e

echo "🚀 Timestamp Converter - Quick Run"
echo "=================================="
echo ""

# Check if already built
if [ -d "./build/Build/Products/Release/TimestampConverter.app" ]; then
    echo "✅ Found existing build"
    echo "🎯 Launching app..."
    open ./build/Build/Products/Release/TimestampConverter.app
    echo ""
    echo "📌 The app is now running in your menu bar"
    echo "   Look for the clock icon in the top-right"
    echo ""
    echo "💡 Quick test:"
    echo "   1. Open TextEdit"
    echo "   2. Type: 1737025200"
    echo "   3. Select the text"
    echo "   4. Press ⌘⇧T"
    exit 0
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed"
    echo ""
    echo "Please either:"
    echo "  1. Install Xcode from the Mac App Store"
    echo "  2. Run: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    echo ""
    echo "Or open the project in Xcode manually:"
    echo "  open TimestampConverter.xcodeproj"
    exit 1
fi

# Build the app
echo "🔨 Building the app (this may take a minute)..."
echo ""

xcodebuild -project TimestampConverter.xcodeproj \
    -scheme TimestampConverter \
    -configuration Release \
    -derivedDataPath ./build \
    build 2>&1 | grep -E "Build|error|warning" || true

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo "🎯 Launching app..."
    open ./build/Build/Products/Release/TimestampConverter.app

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Timestamp Converter is now running!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📌 Look for the clock icon in your menu bar"
    echo ""
    echo "⚠️  First time setup:"
    echo "   You'll be prompted to grant accessibility permissions"
    echo "   This allows the app to read selected text"
    echo ""
    echo "💡 Quick test:"
    echo "   1. Open any app (TextEdit, Safari, etc.)"
    echo "   2. Type: 1737025200"
    echo "   3. Select the text"
    echo "   4. Press ⌘⇧T (Command + Shift + T)"
    echo ""
    echo "📖 For more info, see:"
    echo "   - QUICKSTART.md for detailed setup"
    echo "   - README.md for full documentation"
    echo ""
else
    echo ""
    echo "❌ Build failed"
    echo "Try opening the project in Xcode to see detailed errors:"
    echo "  open TimestampConverter.xcodeproj"
    exit 1
fi