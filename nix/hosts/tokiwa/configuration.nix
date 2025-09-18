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

  networking.hostName = "tokiwa"; # Define your hostname.

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-tokiwa;
}
