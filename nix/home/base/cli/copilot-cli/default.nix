{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "0.0.407";
    src = pkgs.fetchzip {
      url = if pkgs.stdenv.hostPlatform.isDarwin
        then "https://github.com/github/copilot-cli/releases/download/v0.0.407/copilot-darwin-arm64.tar.gz"
        else "https://github.com/github/copilot-cli/releases/download/v0.0.407/copilot-linux-x64.tar.gz";
      sha256 = if pkgs.stdenv.hostPlatform.isDarwin
        then "sha256-pyyM/Dbuf9+dVrlLKiYi9o1hPeKP6TkwcphzFBhBta0="
        else "sha256-HDqQ+Rffrzo1oWh8KrqMTS/YvqJa81LZx7sPxM2exNM=";
    };
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
