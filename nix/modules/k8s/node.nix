{ pkgs, lib, impurelibs, ... }:
let
  cfg = import ./config.nix { inherit impurelibs; };
in
{
  # resolve master hostname
  networking.extraHosts = "${cfg.kubeMasterIP} ${cfg.kubeMasterHostname}";

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = let
    api = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterAPIServerPort}";
  in
  {
    roles = ["node"];
    masterAddress = cfg.kubeMasterHostname;
    easyCerts = true;

    # point kubelet and other services to kube-apiserver
    kubelet.kubeconfig.server = api;
    apiserverAddress = api;

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/kubelet 0755 root root -"
    "d /var/lib/kubelet/pki 0755 root root -"
    "d /var/lib/kubernetes 0755 root root -"
    "d /opt/cni/bin 0755 root root -"
  ];

  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = "infinity";
  };
}
