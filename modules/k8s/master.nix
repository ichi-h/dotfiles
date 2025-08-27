{ config, pkgs, ... }:
let
  vars = import ./vars.nix;
in
{
  # resolve master hostname
  networking.extraHosts = "${vars.kubeMasterIP} ${vars.kubeMasterHostname}";

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = vars.kubeMasterHostname;
    apiserverAddress = "https://${vars.kubeMasterHostname}:${toString vars.kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = vars.kubeMasterAPIServerPort;
      advertiseAddress = vars.kubeMasterIP;
    };

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
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
}
