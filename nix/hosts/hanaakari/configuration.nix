{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/k8s/node.nix
    ../../modules/desktop
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "ceph" ];

  networking.hostName = "hanaakari"; # Define your hostname.

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-hanaakari;

  systemd.tmpfiles.rules = [
    "d /mnt/k8s/volumes/loki 0755 root root -"
    "d /mnt/k8s/volumes/prometheus/server 0755 root root -"
    "d /mnt/k8s/volumes/prometheus/alertmanager 0755 root root -"
    "d /mnt/k8s/volumes/traefik/data 0755 root root -"
    "d /mnt/k8s/volumes/vaultwarden 0755 root root -"
    "d /mnt/k8s/volumes/shared/data 0770 root root -"
    "d /mnt/k8s/volumes/shared/config 0755 root root -"
    "d /mnt/k8s/volumes/shared/custom_apps 0755 root root -"
    "d /mnt/k8s/volumes/shared/themes 0755 root root -"
  ];
}
