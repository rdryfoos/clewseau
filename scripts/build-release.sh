#!/usr/bin/env bash
# Build distributable zips for SpecAssay preset, check extension, and bundle.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/dist"
VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  VERSION="$(awk '/^  version:/{gsub(/"/,""); print $2; exit}' "$ROOT/bundle.yml")"
fi
rm -rf "$DIST"
mkdir -p "$DIST"

# Preset zip — preset.yml at archive root (or single top-level dir)
(
  cd "$ROOT/presets/specassay"
  zip -r "$DIST/specassay-preset-${VERSION}.zip" . -x '*.DS_Store' -x '*__pycache__*'
)

# Extension zip — extension.yml at archive root
(
  cd "$ROOT/extensions/specassay-check"
  zip -r "$DIST/specassay-check-${VERSION}.zip" . -x '*.DS_Store' -x '*__pycache__*'
)

# Bundle artifact via Spec Kit
specify bundle build --path "$ROOT" --output "$DIST"

echo "Built:"
ls -la "$DIST"
