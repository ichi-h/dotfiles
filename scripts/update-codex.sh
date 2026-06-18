#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)/nix/home/base/cli/ai/codex"
MANIFEST_FILE="$DIR/manifest.json"
API_URL="https://api.github.com/repos/openai/codex/releases/latest"

python3 - "$MANIFEST_FILE" "$API_URL" <<'PY'
import json
import sys
import urllib.request

manifest_file = sys.argv[1]
api_url = sys.argv[2]

with open(manifest_file) as file:
    current_manifest = json.load(file)

with urllib.request.urlopen(api_url) as response:
    release = json.load(response)

latest_tag = release["tag_name"]
latest_version = latest_tag.removeprefix("rust-v")
current_version = current_manifest["version"]

if current_version == latest_version:
    print(f"already up to date: {current_version}")
    sys.exit(0)

print(f"updating codex: {current_version} -> {latest_version}")

wanted_assets = {
    "aarch64-apple-darwin": "codex-aarch64-apple-darwin.tar.gz",
    "x86_64-apple-darwin": "codex-x86_64-apple-darwin.tar.gz",
    "aarch64-unknown-linux-musl": "codex-aarch64-unknown-linux-musl.tar.gz",
    "x86_64-unknown-linux-musl": "codex-x86_64-unknown-linux-musl.tar.gz",
}
assets = {asset["name"]: asset for asset in release["assets"]}
platforms = {}

for platform, asset_name in wanted_assets.items():
    asset = assets[asset_name]
    digest = asset.get("digest", "")
    if not digest.startswith("sha256:"):
        raise RuntimeError(f"missing sha256 digest for {asset_name}")

    platforms[platform] = {
        "asset": asset_name,
        "checksum": digest.removeprefix("sha256:"),
        "size": asset["size"],
    }

manifest = {
    "version": latest_version,
    "tag": latest_tag,
    "publishedAt": release["published_at"],
    "platforms": platforms,
}

with open(manifest_file, "w") as file:
    json.dump(manifest, file, indent=2)
    file.write("\n")

print("done")
PY
