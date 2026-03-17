#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/a2dclock.XXXXXX")"
BUNDLE_DIR="$WORK_DIR/A2DClock.saver"
CONTENTS_DIR="$BUNDLE_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
INFO_TEMPLATE="$ROOT_DIR/Support/A2DClockSaver/Info.plist"
EXECUTABLE_NAME="A2DClockSaver"

cleanup() {
  rm -rf "$WORK_DIR"
}

trap cleanup EXIT

echo "Building static package products..."
swift build -c release --package-path "$ROOT_DIR"

BIN_PATH="$(swift build -c release --show-bin-path --package-path "$ROOT_DIR")"
SDK_PATH="$(xcrun --sdk macosx --show-sdk-path)"
TARGET_ARCH="$(uname -m)"
TARGET_TRIPLE="${TARGET_ARCH}-apple-macos13.0"

rm -rf "$DIST_DIR"
mkdir -p "$MACOS_DIR"
cp "$INFO_TEMPLATE" "$CONTENTS_DIR/Info.plist"

echo "Linking ScreenSaver bundle..."
swiftc \
  -sdk "$SDK_PATH" \
  -target "$TARGET_TRIPLE" \
  -parse-as-library \
  -module-name A2DClockSaver \
  -I "$BIN_PATH/Modules" \
  -L "$BIN_PATH" \
  -lA2DClockSurface \
  -lA2DClockCore \
  -framework ScreenSaver \
  -framework SwiftUI \
  -framework AppKit \
  -Xlinker -bundle \
  "$ROOT_DIR/Sources/A2DClockSaver/A2DClockSaverView.swift" \
  -o "$MACOS_DIR/$EXECUTABLE_NAME"

echo "Cleaning bundle metadata..."
xattr -cr "$BUNDLE_DIR"

echo "Signing bundle for local installation..."
codesign --force --deep --sign - "$BUNDLE_DIR" >/dev/null

echo "Verifying signature..."
codesign --verify --deep --strict "$BUNDLE_DIR"

echo "Creating zip artifact..."
mkdir -p "$DIST_DIR"
COPYFILE_DISABLE=1 ditto --noextattr --noqtn "$BUNDLE_DIR" "$DIST_DIR/A2DClock.saver"
(
  cd "$WORK_DIR"
  COPYFILE_DISABLE=1 zip -qry -X "$DIST_DIR/A2DClock.zip" "$(basename "$BUNDLE_DIR")"
)

echo
echo "Built:"
echo "  $DIST_DIR/A2DClock.saver"
echo "  $DIST_DIR/A2DClock.zip"
