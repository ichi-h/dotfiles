{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/k8s/master.nix
    ../../modules/niri
  ];

  networking.hostName = "tokiwa"; # Define your hostname.

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-tokiwa;
}
