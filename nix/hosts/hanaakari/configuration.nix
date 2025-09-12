{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/k8s/node.nix
  ];

  networking.hostName = "hanaakari"; # Define your hostname.

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

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-hanaakari;

  systemd.tmpfiles.rules = [
    "d /mnt/k8s/volumes/loki 0755 root root -"
    "d /mnt/k8s/volumes/prometheus/server 0755 root root -"
    "d /mnt/k8s/volumes/prometheus/alertmanager 0755 root root -"
    "d /mnt/k8s/volumes/traefik 0755 root root -"
    "d /mnt/k8s/volumes/vaultwarden 0755 root root -"
    "d /mnt/k8s/volumes/shared/data 0770 root root -"
    "d /mnt/k8s/volumes/shared/config 0755 root root -"
    "d /mnt/k8s/volumes/shared/custom_apps 0755 root root -"
    "d /mnt/k8s/volumes/shared/themes 0755 root root -"
  ];
}
