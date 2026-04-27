#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)/nix/home/base/cli/ai/claude-code"
MANIFEST_FILE="$DIR/manifest.json"
BASE_URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"

current_version=$(jq -r '.version' "$MANIFEST_FILE")
latest_version=$(curl -fsSL "$BASE_URL/latest")

if [ "$current_version" = "$latest_version" ]; then
  echo "already up to date: $current_version"
  exit 0
fi

echo "updating claude-code: $current_version -> $latest_version"

curl -fsSL "$BASE_URL/$latest_version/manifest.json" --output "$MANIFEST_FILE"

echo "done"
