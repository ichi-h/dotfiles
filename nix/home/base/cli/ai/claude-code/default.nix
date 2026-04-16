{ pkgs, ... }:
let
  # npm view @anthropic-ai/claude-code version
  # nix-prefetch-url --type sha256 https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-X.X.X.tgz

  claudeCode = pkgs.stdenv.mkDerivation {
    pname = "claude-code";
    version = "2.1.110";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.110.tgz";
      sha256 = "0n3ayyavi1nsl6fj1g3wjjsrvb0pckzrq09vw6z96y5jwax8vrm9";
    };

    nativeBuildInputs = [ pkgs.makeWrapper ];

    phases = [ "unpackPhase" "installPhase" ];

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/claude-code
      cp -r package/* $out/lib/claude-code/

      mkdir -p $out/bin
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/claude \
        --add-flags "$out/lib/claude-code/cli.js" \
        --set DISABLE_AUTOUPDATER 1 \
        --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
        --set DISABLE_INSTALLATION_CHECKS 1 \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.procps ]}

      runHook postInstall
    '';
  };
in
{
  home.packages = [ claudeCode ];

  home.file = {
    ".claude/CLAUDE.md".source = ../AGENTS.md;
    ".claude/skills".source = ../skills;
    ".claude/agents".source = ../agents;
    ".claude/settings.json".text = 
        builtins.replaceStrings
          [ "\"%MCP_SERVERS%\"" ]
          [ (builtins.readFile ../mcp/mcp-config.json ) ]
          (builtins.readFile ./settings.json);
  };
}
