{ pkgs, ... }:
let
  manifest = builtins.fromJSON (builtins.readFile ./manifest.json);
  platformKey =
    let
      arch = if pkgs.stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
      os = if pkgs.stdenv.hostPlatform.isDarwin then "apple-darwin" else "unknown-linux-musl";
    in
    "${arch}-${os}";
  platformEntry = manifest.platforms.${platformKey};
  baseUrl = "https://github.com/openai/codex/releases/download";

  codex = pkgs.stdenv.mkDerivation {
    pname = "codex";
    inherit (manifest) version;

    src = pkgs.fetchurl {
      url = "${baseUrl}/${manifest.tag}/${platformEntry.asset}";
      sha256 = platformEntry.checksum;
    };

    phases = [
      "unpackPhase"
      "installPhase"
    ];
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      mkdir source
      tar xzf "$src" -C source
      cd source
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      # Keep the upstream layout: Codex resolves bundled tools/resources
      # relative to its executable and codex-package.json.
      test -f codex-package.json
      mkdir -p "$out"
      cp -R ./. "$out/"
      chmod 0755 "$out/bin/codex" "$out/bin/codex-code-mode-host" "$out/codex-path/rg"
      ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        chmod 0755 "$out/codex-resources/bwrap"
      ''}
      ln -s bin/codex "$out/codex"

      runHook postInstall
    '';
  };
in
{
  home.packages = [ codex ];

  # /agents starts app-server from this fixed standalone path, not from PATH.
  # Keep it on the same Nix-managed release as the CLI across HM switches.
  # Use daemon start/restart; daemon bootstrap enables the upstream installer
  # updater, which would replace this Home Manager-managed link.
  home.file.".codex/packages/standalone/current".source = codex;
}
