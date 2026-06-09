#!/bin/bash
# Build Headroom.app (universal: arm64 + x86_64) and the downloadable zip.
# Output: app/dist/Headroom.app and site/public/Headroom.zip
# Signing: "Developer ID Application" identity when present in the Keychain,
# ad-hoc otherwise (VISION milestone 3 — honest about it on the landing page).
set -euo pipefail
cd "$(dirname "$0")"

VERSION="${1:-0.1.0}"

# No Xcode on this box (CLT only), so build each slice and lipo them.
swift build -c release --triple arm64-apple-macosx13.0
ARM64_BIN=$(swift build -c release --triple arm64-apple-macosx13.0 --show-bin-path)/Headroom
swift build -c release --triple x86_64-apple-macosx13.0
X86_BIN=$(swift build -c release --triple x86_64-apple-macosx13.0 --show-bin-path)/Headroom

rm -rf dist/Headroom.app
mkdir -p dist/Headroom.app/Contents/MacOS
lipo -create "$ARM64_BIN" "$X86_BIN" -output dist/Headroom.app/Contents/MacOS/Headroom

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

IDENTITY=$(security find-identity -v -p codesigning | grep -o '"Developer ID Application: [^"]*"' | head -1 | tr -d '"' || true)
if [ -n "$IDENTITY" ]; then
    codesign --force --deep --options runtime --timestamp --sign "$IDENTITY" dist/Headroom.app
    echo "signed: $IDENTITY"
else
    codesign --force --deep --sign - dist/Headroom.app
    echo "signed: ad-hoc (no Developer ID identity in Keychain yet)"
fi
codesign --verify --deep dist/Headroom.app

ditto -c -k --keepParent dist/Headroom.app ../site/public/Headroom.zip
echo "OK: dist/Headroom.app + site/public/Headroom.zip (v${VERSION}, $(lipo -archs dist/Headroom.app/Contents/MacOS/Headroom))"
