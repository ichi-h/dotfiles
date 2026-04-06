{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "1.0.18";
    src = pkgs.fetchzip {
      url = if !pkgs.stdenv.hostPlatform.isDarwin
        then "https://github.com/github/copilot-cli/releases/download/v1.0.18/copilot-linux-x64.tar.gz"
        else "https://github.com/github/copilot-cli/releases/download/v1.0.18/copilot-darwin-arm64.tar.gz";
      sha256 = if !pkgs.stdenv.hostPlatform.isDarwin
        then "sha256-8kgkla1BlAVzrk3z0ZFHUnGMPPq/2CyCsQxp7X4DFOs="
        else "sha256-ozZR9NV7fKB78s2wlurW5o+0okJmMbn7HwdrMS/Nvxs=";
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
