{ vars, impurelibs, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ impurelibs.secrets.username ];
      LogLevel = "INFO";
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    ports = [ 48195 ];
    openFirewall = true;
  };
}
