{ pkgs, ... }:
let
  copilotCli = pkgs.stdenv.mkDerivation {
    pname = "antigravity-cli";
    version = "1.0.4";
    src = pkgs.fetchzip (
      if !pkgs.stdenv.hostPlatform.isDarwin then
        {
          url = "https://github.com/google-antigravity/antigravity-cli/releases/download/1.0.4/agy_cli_linux_x64.tar.gz";
          sha256 = "sha256-bIfOdECzW1aumL4eAey1udyaGtb4T2120r39WNerlWY=";
        }
      else
        {
          url = "https://github.com/google-antigravity/antigravity-cli/releases/download/1.0.4/agy_cli_mac_arm64.tar.gz";
          sha256 = "sha256-Z88fWVF5Xci3FqamkgStUT2HT+dnybAnwMLwOFpVSUE=";
        }
    );
    phases = [ "installPhase" ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 $src/antigravity $out/bin/agy
      runHook postInstall
    '';
  };
in
{
  home.packages = [ copilotCli ];

  home.file = {
    ".gemini/AGENTS.md".source = ../AGENTS.md;
    ".gemini/skills".source = ../skills;
    ".gemini/mcp-config.json".text = ''
      {
        "mcpServers" : ${builtins.readFile ../mcp/mcp-config.json}
      }
    '';
  };
}
