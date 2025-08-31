{ vars, ... }:
{
  home.username = vars.username;
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
}
