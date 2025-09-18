
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

    # This config is necessary on arm64
    addons.dns = {
      enable = true;
      coredns = {
        finalImageTag = "1.10.1";
        imageDigest = "sha256:a0ead06651cf580044aeb0a0feba63591858fb2e43ade8c9dea45a6a89ae7e5e";
        imageName = "coredns/coredns";
        sha256 = "0c4vdbklgjrzi6qc5020dvi8x3mayq4li09rrq2w0hcjdljj0yf9";
      };
    };

    kubelet.extraOpts = "--fail-swap-on=false --root-dir=/var/lib/kubelet --pod-infra-container-image=registry.k8s.io/pause:3.9";
  };

  # This config is necessary on arm64
  systemd.services.etcd = {
    environment = {
      ETCD_UNSUPPORTED_ARCH = "arm64";
    };
  };

  systemd.services.containerd = {
    serviceConfig = {
      TimeoutStartSec = "300";
    };
    before = [ "kubelet.service" ];
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
