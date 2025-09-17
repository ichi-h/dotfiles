
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

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = cfg.kubeMasterHostname;
    apiserverAddress = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = cfg.kubeMasterAPIServerPort;
      advertiseAddress = cfg.kubeMasterIP;
    };

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false --pod-infra-container-image=registry.k8s.io/pause:3.9";
  };

  systemd.services.k8s-setup = {
    description = "Kubernetes setup";
    wants = ["kubelet.service"];
    wantedBy = ["multi-user.target"];
    requires = ["kubelet.service"];
    requiredBy = ["kubelet.service"];
    after = ["kubelet.service"];
    serviceConfig = {
      User = "root";
      Type = "oneshot";
    };
    script = ''
      chmod +r /var/lib/kubernetes/secrets/cluster-admin.pem
      chmod +r /var/lib/kubernetes/secrets/cluster-admin-key.pem
      if [ ! -e "$HOME/.kube/config" ]; then
        mkdir -p $HOME/.kube
        ln -s /etc/kubernetes/cluster-admin.kubeconfig "$HOME/.kube/config"
      fi
    '';
  };

  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = "infinity";
  };
}
