{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "1.0.26";
    src = pkgs.fetchzip (if !pkgs.stdenv.hostPlatform.isDarwin then {
      url = "https://github.com/github/copilot-cli/releases/download/v1.0.26/copilot-linux-x64.tar.gz";
      sha256 = "sha256-4qvJHVnV8csGJr7ex06bSmxKs0N4Y6/YC1oCRZ74Kmo=";
    } else {
      url = "https://github.com/github/copilot-cli/releases/download/v1.0.26/copilot-darwin-arm64.tar.gz";
      sha256 = "sha256-27lPLAq9aJFJzLeK8OIFlNqx7UjtkkTSo+4ddWvMSig=";
    });
    phases = [ "installPhase" ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m 755 $src/copilot $out/bin/copilot
      runHook postInstall
    '';
  };
in
{
  home.packages = [ copilotCli ];
}
