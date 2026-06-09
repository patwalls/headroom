#!/bin/bash
# Build Headroom.app from the release binary. Output: app/dist/Headroom.app
# Ad-hoc signed until the Apple Developer ID exists (VISION milestone 3).
set -euo pipefail
cd "$(dirname "$0")"

VERSION="${1:-0.1.0}"

swift build -c release

rm -rf dist/Headroom.app
mkdir -p dist/Headroom.app/Contents/MacOS
cp .build/release/Headroom dist/Headroom.app/Contents/MacOS/Headroom

cat > dist/Headroom.app/Contents/Info.plist <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key><string>sh.walls.headroom</string>
    <key>CFBundleName</key><string>Headroom</string>
    <key>CFBundleExecutable</key><string>Headroom</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>${VERSION}</string>
    <key>CFBundleVersion</key><string>${VERSION}</string>
    <key>LSMinimumSystemVersion</key><string>13.0</string>
    <key>LSUIElement</key><true/>
    <key>NSHumanReadableCopyright</key><string>headroom.walls.sh</string>
</dict>
</plist>
PLIST

codesign --force --deep --sign - dist/Headroom.app
codesign --verify --deep dist/Headroom.app && echo "OK: dist/Headroom.app (ad-hoc signed, v${VERSION})"
