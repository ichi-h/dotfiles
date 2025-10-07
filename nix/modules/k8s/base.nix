{
  services.certmgr.renewInterval = "168h";

  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = "1048576";
  };
}
