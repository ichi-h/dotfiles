{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "1.0.32";
    src = pkgs.fetchzip (
      if !pkgs.stdenv.hostPlatform.isDarwin then
        {
          url = "https://github.com/github/copilot-cli/releases/download/v1.0.32/copilot-linux-x64.tar.gz";
          sha256 = "sha256-Mw0Re8xH4HQo4RQ+L19iz4tvGgiZWHL1Y0JrU3UflR4=";
        }
      else
        {
          url = "https://github.com/github/copilot-cli/releases/download/v1.0.32/copilot-darwin-arm64.tar.gz";
          sha256 = "sha256-iX5kALxq6RtV8mGbwa/wx5TW15Ty3TKXoaB89fF49pI=";
        }
    );
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
    ".copilot/copilot-instructions.md".source = ../AGENTS.md;
    ".copilot/skills".source = ../skills;
    ".copilot/agents".source = ../agents;
    ".copilot/mcp-config.json".text = ''
      {
        "mcpServers" : ${builtins.readFile ../mcp/mcp-config.json}
      }
    '';
  };
}
