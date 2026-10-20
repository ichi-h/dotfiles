# pi の extension を targetDirectory 配下へ展開する。
#
# このディレクトリ直下の
#   - *.ts / *.js ファイル (pi が直接読み込む形式)
#   - index.ts / index.js を持つディレクトリ
# をすべて ${targetDirectory}/<名前> として配置する。
# default.nix などの設定ファイルは対象外なので、extension を追加するときは
# このディレクトリにファイル (またはディレクトリ) を置くだけでよい。
#
# 直下の *.ts / *.js は pi がすべて extension として読み込むため、
# 共有ヘルパーはディレクトリを作って index.ts から import すること。
# また flake から参照するため、新規ファイルは git add してから switch すること。
#
# 使い方:
#   imports = [ (import ./extensions ".pi/agent/extensions") ];
targetDirectory:
let
  entries = builtins.readDir ./.;
  # pi の拡張子判定は .ts / .js のみ (dist/core/extensions/loader.js:581)。
  # .mts / .mjs は置いても読み込まれないため対象外とする。
  isExtensionFile =
    name: type:
    type == "regular"
    && builtins.match ".*\\.(ts|js)" name != null
    && builtins.match ".*\\.d\\.ts" name == null;
  isExtensionDir =
    name: type:
    type == "directory"
    && (
      builtins.pathExists (./. + "/${name}/index.ts") || builtins.pathExists (./. + "/${name}/index.js")
    );
  extensionNames = builtins.filter (
    name: isExtensionFile name entries.${name} || isExtensionDir name entries.${name}
  ) (builtins.attrNames entries);
in
{
  home.file = builtins.listToAttrs (
    map (name: {
      name = "${targetDirectory}/${name}";
      value.source = ./. + "/${name}";
    }) extensionNames
  );
}
