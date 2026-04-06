{ pkgs, vars, impurelibs, ... }:
{
  users.mutableUsers = false;

  users.users."${impurelibs.secrets.username}" = {
    home = "/home/${impurelibs.secrets.username}";
    isNormalUser = true;
    description = "ichi";
    extraGroups = [
      impurelibs.secrets.username
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
