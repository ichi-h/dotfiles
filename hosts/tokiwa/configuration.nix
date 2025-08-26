{ config, pkgs, vars, ... }:
let
  keyFile = "/home/${vars.username}/dotfiles/sops/age/tokiwa.txt";
in
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

  sops = {
    age.keyFile = keyFile;
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      hashed-user-passwd-tokiwa.neededForUsers = true;
      tailscale-ip-address-tokiwa.neededForUsers = true;
    };
  };


  users.users."${vars.username}".hashedPasswordFile = config.sops.secrets.hashed-user-passwd-tokiwa.path;

  environment.variables = {
    SOPS_AGE_KEY_FILE = keyFile;
  };
}
