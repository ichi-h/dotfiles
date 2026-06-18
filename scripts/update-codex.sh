#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)/nix/home/base/cli/ai/codex"
MANIFEST_FILE="$DIR/manifest.json"
API_URL="https://api.github.com/repos/openai/codex/releases/latest"

current_version=$(jq -r '.version' "$MANIFEST_FILE")
release_file=$(mktemp)
manifest_tmp=$(mktemp "$DIR/manifest.json.XXXXXX")
trap 'rm -f "$release_file" "$manifest_tmp"' EXIT

curl -fsSL \
  -H 'Accept: application/vnd.github+json' \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  "$API_URL" \
  --output "$release_file"

latest_tag=$(jq -r '.tag_name' "$release_file")
latest_version=${latest_tag#rust-v}

if [ "$current_version" = "$latest_version" ]; then
  echo "already up to date: $current_version"
  exit 0
fi

echo "updating codex: $current_version -> $latest_version"

jq '
  . as $release
  | def asset($name):
      ($release.assets | map(select(.name == $name)) | first) as $asset
      | if $asset == null then
          error("missing release asset: \($name)")
        elif (($asset.digest // "") | startswith("sha256:") | not) then
          error("missing sha256 digest: \($name)")
        else
          {
            asset: $asset.name,
            checksum: ($asset.digest | sub("^sha256:"; "")),
            size: $asset.size
          }
        end;
    {
      version: ($release.tag_name | sub("^rust-v"; "")),
      tag: $release.tag_name,
      publishedAt: $release.published_at,
      platforms: {
        "aarch64-apple-darwin": asset("codex-aarch64-apple-darwin.tar.gz"),
        "x86_64-apple-darwin": asset("codex-x86_64-apple-darwin.tar.gz"),
        "aarch64-unknown-linux-musl": asset("codex-aarch64-unknown-linux-musl.tar.gz"),
        "x86_64-unknown-linux-musl": asset("codex-x86_64-unknown-linux-musl.tar.gz")
      }
    }
' "$release_file" > "$manifest_tmp"

mv "$manifest_tmp" "$MANIFEST_FILE"

echo "done"
