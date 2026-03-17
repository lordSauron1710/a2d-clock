#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_ARTIFACT="${1:-$ROOT_DIR/dist/A2DClock.zip}"
INSTALL_DIR="$HOME/Library/Screen Savers"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/a2dclock-install.XXXXXX")"

cleanup() {
  rm -rf "$WORK_DIR"
}

trap cleanup EXIT

if [[ ! -e "$SOURCE_ARTIFACT" ]]; then
  echo "Missing saver artifact: $SOURCE_ARTIFACT" >&2
  echo "Run scripts/build-saver.sh first." >&2
  exit 1
fi

if [[ -d "$SOURCE_ARTIFACT" ]]; then
  SOURCE_BUNDLE="$SOURCE_ARTIFACT"
else
  unzip -qq "$SOURCE_ARTIFACT" -d "$WORK_DIR"
  SOURCE_BUNDLE="$WORK_DIR/A2DClock.saver"
fi

TARGET_BUNDLE="$INSTALL_DIR/$(basename "$SOURCE_BUNDLE")"

mkdir -p "$INSTALL_DIR"
rm -rf "$TARGET_BUNDLE"
COPYFILE_DISABLE=1 ditto --noextattr --noqtn "$SOURCE_BUNDLE" "$TARGET_BUNDLE"
xattr -cr "$TARGET_BUNDLE" || true

echo "Installed to:"
echo "  $TARGET_BUNDLE"
echo
echo "Open System Settings > Screen Saver to enable it."
