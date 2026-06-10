#!/bin/bash
# Verification harness: build + run `headroom --print` WITHOUT spamming Keychain dialogs.
# Ad-hoc signatures change every rebuild, so macOS treats each dev build as a new app
# and re-asks for the Claude Code keychain item. Signing with the Developer ID cert and
# a STABLE identifier gives every dev build the same code identity — "Always Allow"
# sticks once, forever.
set -euo pipefail
cd "$(dirname "$0")"

swift build >/dev/null

IDENTITY=$(security find-identity -v -p codesigning | grep -o '"Developer ID Application: [^"]*"' | head -1 | tr -d '"' || true)
if [ -n "$IDENTITY" ]; then
    codesign --force --identifier sh.walls.headroom.dev --sign "$IDENTITY" .build/debug/Headroom 2>/dev/null
fi

exec .build/debug/Headroom --print
