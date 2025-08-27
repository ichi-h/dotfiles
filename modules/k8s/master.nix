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
}
