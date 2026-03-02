{ pkgs, ... }:
let
  opencode = pkgs.stdenv.mkDerivation {
    pname = "opencode";
    version = "1.2.15";
    src = pkgs.fetchzip {
      url = if pkgs.stdenv.hostPlatform.isDarwin
        then "https://github.com/anomalyco/opencode/releases/download/v1.2.15/opencode-darwin-arm64.zip"
        else "https://github.com/anomalyco/opencode/releases/download/v1.2.15/opencode-linux-x64.tar.gz";
      sha256 = if pkgs.stdenv.hostPlatform.isDarwin
        then "sha256-Oqd72EXzUWLFaslt+OnkAk4TmpLdhmE1CdyyHhZSgZo="
        else "sha256-rguw/Yjz3nlZcUgpEilqkLeQeIxpAA1QAJQI2Ud61FM=";
      stripRoot = false;
    };
    phases = [ "installPhase" ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m 755 $src/opencode $out/bin/opencode
      runHook postInstall
    '';
  };
in
{
  home.packages = [ opencode ];
  home.file = {
    ".config/opencode/config.json".source = ./config.json;
    ".config/opencode/oh-my-opencode.json".source = ./oh-my-opencode.json;
    ".config/opencode/opencode.json".source = ./opencode.json;
  };
}
