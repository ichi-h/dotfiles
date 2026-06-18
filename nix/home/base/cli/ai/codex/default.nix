{ pkgs, ... }:
let
  codex = pkgs.stdenv.mkDerivation {
    pname = "codex";
    version = "0.140.0";
    src = pkgs.fetchzip (
      if pkgs.stdenv.hostPlatform.isDarwin then
        {
          url = "https://github.com/openai/codex/releases/download/rust-v0.140.0/codex-aarch64-apple-darwin.tar.gz";
          sha256 = "sha256-S2juKqJ1Ctlq/n4R/nPWouz9NYiThSa4QnF1MGZv+9E=";
        }
      else
        {
          url = "https://github.com/openai/codex/releases/download/rust-v0.140.0/codex-x86_64-unknown-linux-musl.tar.gz";
          sha256 = "sha256-AQKv2s06eOFD3Q5p8lK7OBLbfzQko3W4xd1mGFj3rss=";
        }
    );
    phases = [ "installPhase" ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 $src/codex-* $out/bin/codex
      runHook postInstall
    '';
  };
in
{
  home.packages = [ codex ];
}
