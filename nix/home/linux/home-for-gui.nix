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
    ../base/gui
    ../base/home.nix
    ./base
    ./gui
  ];

  nixpkgs.config.allowUnfree = true;

  home.homeDirectory = "/home/${impurelibs.secrets.username}";
}
