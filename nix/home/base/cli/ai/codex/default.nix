{ pkgs, ... }:
let
  manifest = builtins.fromJSON (builtins.readFile ./manifest.json);
  platformKey =
    let
      arch =
        if pkgs.stdenv.hostPlatform.isAarch64 then
          "aarch64"
        else
          "x86_64";
      os =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "apple-darwin"
        else
          "unknown-linux-musl";
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

    phases = [ "unpackPhase" "installPhase" ];
    sourceRoot = ".";
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm755 ./codex-* $out/bin/codex

      runHook postInstall
    '';
  };
in
{
  home.packages = [ codex ];
}
