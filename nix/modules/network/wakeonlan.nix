interface:
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ethtool
  ];

  systemd.services.wol-enable = {
    description = "Enable Wake-on-LAN";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s ${interface} wol g";
      RemainAfterExit = true;
    };
  };
}
