#!/usr/bin/env bash
set -euo pipefail

NIX_FILE="$(cd "$(dirname "$0")/.." && pwd)/nix/home/base/cli/ai/claude-code/default.nix"

current_version=$(grep 'version = ' "$NIX_FILE" | sed 's/.*version = "\(.*\)";/\1/')
latest_version=$(npm view @anthropic-ai/claude-code version)

if [ "$current_version" = "$latest_version" ]; then
  echo "already up to date: $current_version"
  exit 0
fi

echo "updating claude-code: $current_version -> $latest_version"

url="https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${latest_version}.tgz"
sha256=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)

sed -i '' \
  -e "s|version = \"${current_version}\";|version = \"${latest_version}\";|" \
  -e "s|url = \"https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${current_version}.tgz\";|url = \"${url}\";|" \
  -e "s|sha256 = \".*\";|sha256 = \"${sha256}\";|" \
  "$NIX_FILE"

echo "done"
