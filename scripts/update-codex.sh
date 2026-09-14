#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)/nix/home/base/cli/ai/codex"
MANIFEST_FILE="$DIR/manifest.json"
CODE_MODE_HOST_MANIFEST_FILE="$DIR/manifest-code-mode-host.json"
API_URL="https://api.github.com/repos/openai/codex/releases/latest"

release_file=$(mktemp)
manifest_tmp=$(mktemp "$DIR/manifest.json.XXXXXX")
code_mode_host_manifest_tmp=$(mktemp "$DIR/manifest-code-mode-host.json.XXXXXX")
trap 'rm -f "$release_file" "$manifest_tmp" "$code_mode_host_manifest_tmp"' EXIT

curl -fsSL \
  -H 'Accept: application/vnd.github+json' \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  "$API_URL" \
  --output "$release_file"

latest_tag=$(jq -r '.tag_name' "$release_file")
latest_version=${latest_tag#rust-v}

# def asset($name): 指定したアセットが release_file に存在するかを確認し、
# あれば checksum 等を含むオブジェクトを、無ければエラーを返す共通関数
ASSET_FN='
  def asset($name):
    (.assets | map(select(.name == $name)) | first) as $asset
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
'

update_manifest() {
  local manifest_file="$1"
  local manifest_tmp_file="$2"
  local jq_filter="$3"
  local label="$4"

  local current_version
  current_version=$(jq -r '.version' "$manifest_file")

  if [ "$current_version" = "$latest_version" ]; then
    echo "$label: already up to date ($current_version)"
    return
  fi

  echo "updating $label: $current_version -> $latest_version"

  jq "$ASSET_FN"'
    . as $release
    | '"$jq_filter" "$release_file" > "$manifest_tmp_file"

  mv "$manifest_tmp_file" "$manifest_file"
}

update_manifest "$MANIFEST_FILE" "$manifest_tmp" '
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
' "codex"

update_manifest "$CODE_MODE_HOST_MANIFEST_FILE" "$code_mode_host_manifest_tmp" '
  {
    version: ($release.tag_name | sub("^rust-v"; "")),
    tag: $release.tag_name,
    publishedAt: $release.published_at,
    platforms: {
      "aarch64-apple-darwin": asset("codex-code-mode-host-aarch64-apple-darwin.tar.gz"),
      "x86_64-apple-darwin": asset("codex-code-mode-host-x86_64-apple-darwin.tar.gz"),
      "aarch64-unknown-linux-musl": asset("codex-code-mode-host-aarch64-unknown-linux-musl.tar.gz"),
      "x86_64-unknown-linux-musl": asset("codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz")
    }
  }
' "codex-code-mode-host"

echo "done"
