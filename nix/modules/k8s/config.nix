{ impurelibs, ... }:
{
  # When using easyCerts=true the IP Address must resolve to the master on creation.
  # So use simply 127.0.0.1 in that case. Otherwise you will have errors like this https://github.com/NixOS/nixpkgs/issues/59364
  kubeMasterIP = impurelibs.secrets.ip-address-yomogi.private;
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
}
