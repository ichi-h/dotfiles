{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "1.0.25";
    src = pkgs.fetchzip (if !pkgs.stdenv.hostPlatform.isDarwin then {
      url = "https://github.com/github/copilot-cli/releases/download/v1.0.25/copilot-linux-x64.tar.gz";
      sha256 = "sha256-aDkVZzKoKQ7x96Kl6w/s/lKmlpQyMBYEzPdvoBi4F+I=";
    } else {
      url = "https://github.com/github/copilot-cli/releases/download/v1.0.25/copilot-darwin-arm64.tar.gz";
      sha256 = "sha256-GCY4oBed0tiRBT3DiCtlirKFN4lbYOkNSxcTgMVs5Og=";
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
  home.file = {
    ".copilot/copilot-instructions.md".source = ./copilot-instructions.md;
    ".copilot/mcp-config.json".source = ./mcp-config.json;
    ".copilot/skills".source = ./skills;
    ".copilot/agents".source = ./agents;
  };
}
