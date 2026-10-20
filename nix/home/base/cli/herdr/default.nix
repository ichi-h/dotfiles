{
  pkgs,
  lib,
  herdr,
  ...
}:
{
  home.packages = [
    herdr.packages.${pkgs.system}.default
  ];

  # Herdr はテーマ等の変更を実行時に config.toml へ書き戻す。
  # Home Manager の home.file は読み取り専用のシンボリックリンクを作成するため、
  # 通常ファイルとして配置する。activation 実行時にリポジトリ側の内容で上書きされる点に注意。
  home.activation.installHerdrConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/herdr"
    # Herdr が config.toml を読み取り専用で書き戻すことがあるため、先に削除してから配置する。
    $DRY_RUN_CMD rm -f "$HOME/.config/herdr/config.toml"
    $DRY_RUN_CMD cp "${./config.toml}" "$HOME/.config/herdr/config.toml"
    # config.toml の [ui.sound].path は config.toml からの相対パスで解決されるため、
    # 効果音ファイルも同じディレクトリへ配置する。
    $DRY_RUN_CMD cp "${./call-bell.mp3}" "$HOME/.config/herdr/call-bell.mp3"
  '';
}
