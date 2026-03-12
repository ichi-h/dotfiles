{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "1.0.4";
    src = pkgs.fetchzip {
      url = if pkgs.stdenv.hostPlatform.isDarwin
        then "https://github.com/github/copilot-cli/releases/download/v1.0.4/copilot-darwin-arm64.tar.gz"
        else "https://github.com/github/copilot-cli/releases/download/v1.0.4/copilot-linux-x64.tar.gz";
      sha256 = if pkgs.stdenv.hostPlatform.isDarwin
        then "sha256-AWeLJBBnasMjWDkG85jNr4X/id+QXajcGGlKl17rvgc="
        else "sha256-QQhYsVheQqKcNubFKDXnk4q/lfYhV2EWjeHOS1pe9M0=";
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
