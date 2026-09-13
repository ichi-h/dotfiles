{
  pkgs,
  lib,
  config,
  impurelibs,
  ...
}:
let
  cfg = import ./config.nix { inherit impurelibs; };
in
{
  imports = [
    ./base.nix
  ];

  # resolve master hostname
  networking.extraHosts = "${cfg.kubeMasterIP} ${cfg.kubeMasterHostname}";
  networking.firewall.allowedTCPPorts = [ cfg.kubeMasterAPIServerPort ];

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes = {
    roles = [
      "master"
      "node"
    ];
    masterAddress = cfg.kubeMasterHostname;
    apiserverAddress = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterAPIServerPort}";
    easyCerts = true;
    apiserver = {
      securePort = cfg.kubeMasterAPIServerPort;
      advertiseAddress = cfg.kubeMasterIP;
      allowPrivileged = true;
    };

    # This config is necessary on arm64
    addons.dns = {
      enable = true;
      corednsImage = pkgs.dockerTools.pullImage {
        finalImageTag = "1.14.7";
        imageName = "coredns/coredns";
        imageDigest = "sha256:7efd3c635b03efd68c4e8398fc45f0d993d0e9ab016f72c1cefb0fd6d01aa286";
        hash = "sha256-twsVR8lvUW49wJLm9Sdafq8GiEyYablFPSb9cVcHDXw=";
      };
    };

    kubelet.extraOpts = "--fail-swap-on=false --root-dir=/var/lib/kubelet --pod-infra-container-image=registry.k8s.io/pause:3.9";

    proxy.extraOpts = "--masquerade-all";
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
    wants = [ "kubelet.service" ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "kubelet.service" ];
    requiredBy = [ "kubelet.service" ];
    after = [ "kubelet.service" ];
    serviceConfig = {
      User = "root";
      Type = "oneshot";
    };
    script = ''
      if [ ! -e "$HOME/.kube/config" ]; then
        mkdir -p $HOME/.kube
        ln -s /etc/kubernetes/cluster-admin.kubeconfig "$HOME/.kube/config"
      fi
    '';
  };

  systemd.services.flannel = {
    serviceConfig = {
      ExecStart = lib.mkForce "${pkgs.flannel}/bin/flannel -ip-masq";
    };
  };
}
