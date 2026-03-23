{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "github-copilot-cli";
    version = "1.0.10";
    src = pkgs.fetchzip {
      url = if !pkgs.stdenv.hostPlatform.isDarwin
        then "https://github.com/github/copilot-cli/releases/download/v1.0.10/copilot-linux-x64.tar.gz"
        else "https://github.com/github/copilot-cli/releases/download/v1.0.10/copilot-darwin-arm64.tar.gz";
      sha256 = if !pkgs.stdenv.hostPlatform.isDarwin
        then "sha256-LFFuzDXj2zuRl/W7BUbGvd95bhbO4M/9rjcaUM+pIr0="
        else "sha256-W7jqyKIPgzMHlAEzxeLZzNhS9GH+W6yymhTJbQa+Brc=";
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
