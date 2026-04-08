{ vars, impurelibs, ... }:
{
  home.username = impurelibs.secrets.username;
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
