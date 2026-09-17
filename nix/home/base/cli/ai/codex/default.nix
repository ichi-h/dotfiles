{ pkgs, ... }:
let
  manifest = builtins.fromJSON (builtins.readFile ./manifest.json);
  platformKey =
    let
      arch = if pkgs.stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
      os = if pkgs.stdenv.hostPlatform.isDarwin then "apple-darwin" else "unknown-linux-musl";
    in
    "${arch}-${os}";
  platformEntry = manifest.platforms.${platformKey};
  baseUrl = "https://github.com/openai/codex/releases/download";

  codex = pkgs.stdenv.mkDerivation {
    pname = "codex";
    inherit (manifest) version;

    src = pkgs.fetchurl {
      url = "${baseUrl}/${manifest.tag}/${platformEntry.asset}";
      sha256 = platformEntry.checksum;
    };

    phases = [
      "unpackPhase"
      "installPhase"
    ];
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      mkdir source
      tar xzf "$src" -C source
      cd source
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      # Keep the upstream layout: Codex resolves bundled tools/resources
      # relative to its executable and codex-package.json.
      test -f codex-package.json
      mkdir -p "$out"
      cp -R ./. "$out/"
      chmod 0755 "$out/bin/codex" "$out/bin/codex-code-mode-host" "$out/codex-path/rg"
      ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        chmod 0755 "$out/codex-resources/bwrap"
      ''}
      ln -s bin/codex "$out/codex"

      runHook postInstall
    '';
  };

  codexWrapper = pkgs.writers.writePython3Bin "codex" { } ''
    import json
    import os
    import sys
    from pathlib import Path


    def main() -> None:
        project = json.dumps(str(Path.cwd()))
        config = f'projects={{{project}={{trust_level="trusted"}}}}'
        codex_root = Path(
            "${codex}"
        )
        codex_path = codex_root / "bin" / "codex"
        arguments = ["codex", "-c", config, *sys.argv[1:]]
        os.execv(codex_path, arguments)


    if __name__ == "__main__":
        main()
  '';
in
{
  imports = [
    (import ../skills ".codex/skills")
  ];

  home.packages = [
    # Expose the wrapper as `codex`; it invokes the packaged CLI by absolute
    # path so that it cannot recurse into itself.
    codexWrapper

    # dependencies
    pkgs.bubblewrap  
  ];

  home.file = {
    # /agents starts app-server from this fixed standalone path, not from PATH.
    # Keep it on the same Nix-managed release as the CLI across HM switches.
    # Use daemon start/restart; daemon bootstrap enables the upstream installer
    # updater, which would replace this Home Manager-managed link.
    ".codex/packages/standalone/current".source = codex;
    ".codex/config.toml".source = ./config.toml;
    ".codex/AGENTS.md".source = ../AGENTS.md;
  };
}
