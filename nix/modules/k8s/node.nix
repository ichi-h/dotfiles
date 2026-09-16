{
  pkgs,
  lib,
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

  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  services.kubernetes =
    let
      api = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterAPIServerPort}";
    in
    {
      roles = [ "node" ];
      masterAddress = cfg.kubeMasterHostname;
      easyCerts = true;

      # point kubelet and other services to kube-apiserver
      kubelet.kubeconfig.server = api;
      apiserverAddress = api;

      # use coredns
      addons.dns = {
        enable = true;
        corednsImage = pkgs.dockerTools.pullImage {
          finalImageTag = "1.14.7";
          imageName = "coredns/coredns";
          imageDigest = "sha256:7efd3c635b03efd68c4e8398fc45f0d993d0e9ab016f72c1cefb0fd6d01aa286";
          hash = "sha256-sTDGI3KRCsB8Q8G5QHfDc2nDsg8FYNJ4fIxuGhsRUFU=";
        };
      };

      kubelet.extraOpts = "--fail-swap-on=false --root-dir=/var/lib/kubelet";
    };

  systemd.tmpfiles.rules = [
    "d /var/lib/kubelet 0755 root root -"
    "d /var/lib/kubelet/pki 0755 root root -"
    "d /var/lib/kubernetes 0755 root root -"
    "d /var/lib/kubernetes/.kube 0750 kubernetes kubernetes -"
    "f /var/lib/kubernetes/.kube/kuberc 0600 kubernetes kubernetes -"
    "d /opt/cni/bin 0755 root root -"
  ];
}
