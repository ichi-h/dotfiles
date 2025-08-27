{ pkgs, vars, ... }:
{
  users.mutableUsers = false;

  users.users."${vars.username}" = {
    home = "/home/${vars.username}";
    isNormalUser = true;
    description = "ichi";
    extraGroups = [
      vars.username
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgApvzRYRyLf6I7DJ3cyWXAGVXJ3p3eOkzbfHaphgh/"
    ];
  };
}
