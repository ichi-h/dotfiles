{ vars, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ vars.username ];
      LogLevel = "VERBOSE";
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    ports = [ 48195 ];
    openFirewall = true;
  };
}
