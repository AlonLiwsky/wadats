#!/bin/bash

# Build script for Timestamp Converter
# This script builds the app using Xcode

set -e

echo "🔨 Building Timestamp Converter..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or xcodebuild is not in PATH"
    echo "Please install Xcode from the Mac App Store"
    echo "Then run: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    exit 1
fi

# Build the project
xcodebuild -project TimestampConverter.xcodeproj \
    -scheme TimestampConverter \
    -configuration Release \
    -derivedDataPath ./build \
    build

echo "✅ Build completed successfully!"
echo "📦 App location: ./build/Build/Products/Release/TimestampConverter.app"
echo ""
echo "To install:"
echo "  cp -R ./build/Build/Products/Release/TimestampConverter.app /Applications/"
echo ""
echo "To run from current location:"
echo "  open ./build/Build/Products/Release/TimestampConverter.app"