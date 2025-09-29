#!/bin/bash

# Direct Swift build without Xcode IDE
# This script builds the app using only command-line tools

set -e

echo "🔨 Building TimestampConverter without Xcode IDE..."
echo ""

# Create build directory
BUILD_DIR="./DirectBuild"
APP_NAME="TimestampConverter.app"
PRODUCT_DIR="$BUILD_DIR/$APP_NAME"

rm -rf "$BUILD_DIR"
mkdir -p "$PRODUCT_DIR/Contents/MacOS"
mkdir -p "$PRODUCT_DIR/Contents/Resources"

echo "📝 Compiling Swift files..."

# Compile all Swift files
swiftc \
    -o "$PRODUCT_DIR/Contents/MacOS/TimestampConverter" \
    -module-name TimestampConverter \
    -target arm64-apple-macos12.0 \
    -swift-version 5 \
    -Xlinker -rpath -Xlinker @executable_path/../Frameworks \
    -framework Cocoa \
    -framework SwiftUI \
    -framework Carbon \
    TimestampConverter/TimestampConverterApp.swift \
    TimestampConverter/AppDelegate.swift \
    TimestampConverter/Core/TimestampConverter.swift \
    TimestampConverter/Core/GlobalHotKeyManager.swift \
    TimestampConverter/Core/ConversionResult.swift \
    TimestampConverter/UI/PopupWindow.swift \
    TimestampConverter/UI/SettingsView.swift

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed"
    exit 1
fi

echo "📦 Creating app bundle..."

# Create proper Info.plist
cat > "$PRODUCT_DIR/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>TimestampConverter</string>
	<key>CFBundleIdentifier</key>
	<string>com.timestampconverter.app</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>TimestampConverter</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSMinimumSystemVersion</key>
	<string>12.0</string>
	<key>LSUIElement</key>
	<true/>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>Convert Timestamp</string>
			</dict>
			<key>NSMessage</key>
			<string>convertTimestamp</string>
			<key>NSPortName</key>
			<string>TimestampConverter</string>
			<key>NSSendTypes</key>
			<array>
				<string>NSStringPboardType</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
PLIST

# Copy Assets
cp -R TimestampConverter/Assets.xcassets "$PRODUCT_DIR/Contents/Resources/" 2>/dev/null || true

# Create PkgInfo
echo "APPL????" > "$PRODUCT_DIR/Contents/PkgInfo"

# Make executable
chmod +x "$PRODUCT_DIR/Contents/MacOS/TimestampConverter"

echo ""
echo "✅ Build successful!"
echo "📍 App location: $PRODUCT_DIR"
echo ""
echo "To run:"
echo "  open $PRODUCT_DIR"
echo ""
echo "To install:"
echo "  cp -R $PRODUCT_DIR /Applications/"