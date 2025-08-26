{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
  ];

  networking.hostName = "tokiwa"; # Define your hostname.

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.vscode-server.enable = true;
}
