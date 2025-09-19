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
  boot.kernelModules = [ "ceph" "rbd" ];

  networking = {
    hostName = "tokiwa"; # Define your hostname.
    networkmanager.unmanaged = [ "enp1s0" ];
    interfaces.enp1s0 = {
      ipv4.addresses = [{
        address = impurelibs.secrets.ip-address-tokiwa.private;
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.10.1";
    nameservers = [ "192.168.10.1" "8.8.8.8" ];
  };

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-tokiwa;
}
