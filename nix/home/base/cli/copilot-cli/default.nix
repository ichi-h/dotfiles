{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "0.0.422";
    src = pkgs.fetchzip {
      url = if pkgs.stdenv.hostPlatform.isDarwin
        then "https://github.com/github/copilot-cli/releases/download/v0.0.422/copilot-darwin-arm64.tar.gz"
        else "https://github.com/github/copilot-cli/releases/download/v0.0.422/copilot-linux-x64.tar.gz";
      sha256 = if pkgs.stdenv.hostPlatform.isDarwin
        then "sha256-pM/bGFil+zAw8SN28ajK3EN6g9slav7grZ9RkfKeHTA="
        else "sha256-eDZlzibOqZQgib3e+adsjDblnwABGFP/aAwfh18goyY=";
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
