{ impurelibs, ... }:
{
    services.coredns = {
      enable = true;
      extraArgs = [
        "-dns.port=53"
      ];
      config = ''
.:53 {
  log
  errors

  template IN A home.ichi-h.com {
    match "^(.+\.)?home\.ichi-h\.com\.$"
    answer "{{ .Name }} 60 IN A ${impurelibs.secrets.ip-address-hanaakari.tailscale}"
    fallthrough
  }

  forward . 1.1.1.1 1.0.0.1

  cache 30
  health
}'';
    };
}
