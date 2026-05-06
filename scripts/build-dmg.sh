#!/usr/bin/env bash

set -euo pipefail

APP_NAME="gpui"
BUNDLE_ID="com.gpui.app"
VERSION="1.0"

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT_DIR/target/release"
DIST_NATIVE_DIR="$ROOT_DIR/dist/native"
APP_DIR="$TARGET_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
DMG_DIR="$TARGET_DIR/dmg"
DMG_PATH="$DMG_DIR/$APP_NAME.dmg"

echo "==> Creating .app bundle"
rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "==> Copying Rust binary"
cp "$TARGET_DIR/$APP_NAME" "$MACOS_DIR/"

echo "==> Copying Swift binaries"
cp -a "$DIST_NATIVE_DIR"/* "$MACOS_DIR/"

echo "==> Making binaries executable"
chmod +x "$MACOS_DIR/"*

echo "==> Creating Info.plist"
cat > "$CONTENTS_DIR/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>

  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>

  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>

  <key>CFBundleVersion</key>
  <string>$VERSION</string>

  <key>CFBundlePackageType</key>
  <string>APPL</string>

  <key>LSMinimumSystemVersion</key>
  <string>11.0</string>
</dict>
</plist>
EOF

echo "==> Preparing DMG folder"
rm -rf "$DMG_DIR"
mkdir -p "$DMG_DIR"

cp -r "$APP_DIR" "$DMG_DIR/"
ln -s /Applications "$DMG_DIR/Applications"

echo "==> Creating DMG"
rm -f "$DMG_PATH"

hdiutil create \
  -volname "$APP_NAME" \
  -srcfolder "$DMG_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH"

echo "==> Done!"
echo "DMG available at: $DMG_PATH"