{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "0.0.420";
    src = pkgs.fetchzip {
      url = if pkgs.stdenv.hostPlatform.isDarwin
        then "https://github.com/github/copilot-cli/releases/download/v0.0.420/copilot-darwin-arm64.tar.gz"
        else "https://github.com/github/copilot-cli/releases/download/v0.0.420/copilot-linux-x64.tar.gz";
      sha256 = if pkgs.stdenv.hostPlatform.isDarwin
        then "sha256-CMkqI3S4IdzAOFNC1LA7XHWgFVd9gcXnjP0Ff4gVoPk="
        else "sha256-Y5HudaaF64VVelDxlyzWsT1pqgm+nFKm6J++T5pReW0=";
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
  home.file = {
    ".copilot/copilot-instructions.md".source = ./copilot-instructions.md;
    ".copilot/mcp-config.json".source = ./mcp-config.json;
    ".copilot/skills".source = ./skills;
    ".copilot/agents".source = ./agents;
  };
}
