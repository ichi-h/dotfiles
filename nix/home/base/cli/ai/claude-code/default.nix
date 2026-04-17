{ pkgs, ... }:
let
  claudeCode = pkgs.stdenv.mkDerivation {
    pname = "claude-code";
    version = "2.1.112";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.112.tgz";
      sha256 = "02fylpn9lgyk22fq1x3iv5yv2z2cpvg7g3qs4gyyb82kx9lrjdw4";
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
    ".claude/settings.json".source = ./settings.json;
  };
}
