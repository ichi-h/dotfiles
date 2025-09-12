{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/coredns
    ../../modules/k8s/master.nix
    ../../modules/desktop
  ];

  networking.hostName = "tokiwa"; # Define your hostname.

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-tokiwa;
}
