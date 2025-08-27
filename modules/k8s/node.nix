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

  services.kubernetes = let
    api = "https://${vars.kubeMasterHostname}:${toString vars.kubeMasterAPIServerPort}";
  in
  {
    roles = ["node"];
    masterAddress = vars.kubeMasterHostname;
    easyCerts = true;

    # point kubelet and other services to kube-apiserver
    kubelet.kubeconfig.server = api;
    apiserverAddress = api;

    # use coredns
    addons.dns.enable = true;

    # needed if you use swap
    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
