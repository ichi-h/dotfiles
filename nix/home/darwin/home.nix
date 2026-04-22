{
  config,
  pkgs,
  vars,
  impurelibs,
  ...
}:
{
  imports = [
    ../base/cli
    ../base/home.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    homeDirectory = "/Users/${impurelibs.secrets.username}";
    file.".config/karabiner/karabiner.json" = {
      source = ./karabiner.json;
    };
  };
}
