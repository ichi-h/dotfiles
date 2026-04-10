{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "1.0.22";
    src = pkgs.fetchzip (if !pkgs.stdenv.hostPlatform.isDarwin then {
      url = "https://github.com/github/copilot-cli/releases/download/v1.0.22/copilot-linux-x64.tar.gz";
      sha256 = "sha256-GkMu9j5jzTcWWNe4eDdga4BTvKUmentg90UvDetwkT4=";
    } else {
      url = "https://github.com/github/copilot-cli/releases/download/v1.0.22/copilot-darwin-arm64.tar.gz";
      sha256 = "sha256-FT40Gjj1ZWu5BVqGbwX7uRzVFFPcc+BANRonw+YD0r8=";
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
