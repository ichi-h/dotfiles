{ pkgs, ... }:
let
  manifest = builtins.fromJSON (builtins.readFile ./manifest.json);
  platformKey =
    let
      os = if pkgs.stdenv.hostPlatform.isDarwin then "darwin" else "linux";
      arch = if pkgs.stdenv.hostPlatform.isAarch64 then "arm64" else "x64";
    in
    "${os}-${arch}";
  platformEntry = manifest.platforms.${platformKey};
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";

  claudeCode = pkgs.stdenvNoCC.mkDerivation {
    pname = "claude-code";
    inherit (manifest) version;

    src = pkgs.fetchurl {
      url = "${baseUrl}/${manifest.version}/${platformKey}/claude";
      sha256 = platformEntry.checksum;
    };

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs =
      [ pkgs.makeBinaryWrapper ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isElf [ pkgs.autoPatchelfHook ];

    installPhase = ''
      runHook preInstall

      install -Dm755 $src $out/bin/claude

      wrapProgram $out/bin/claude \
        --set DISABLE_AUTOUPDATER 1 \
        --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
        --set DISABLE_INSTALLATION_CHECKS 1 \
        --set USE_BUILTIN_RIPGREP 0 \
        --prefix PATH : ${pkgs.lib.makeBinPath (
          [
            pkgs.procps
            pkgs.ripgrep
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            pkgs.bubblewrap
            pkgs.socat
          ]
        )}

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
