{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/k8s/node.nix
    ../../modules/desktop
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tokiwa"; # Define your hostname.

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-tokiwa;
}
