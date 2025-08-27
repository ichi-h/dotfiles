{ config, pkgs, vars, ... }:
let
  keyFile = "/home/${vars.username}/dotfiles/sops/age/tokiwa.txt";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    # ../../modules/k8s/master.nix
  ];

  networking.hostName = "tokiwa"; # Define your hostname.

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };

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
    };
  };


  users.users."${vars.username}".hashedPasswordFile = config.sops.secrets.hashed-user-passwd-tokiwa.path;

  environment.variables = {
    SOPS_AGE_KEY_FILE = keyFile;
  };
}
