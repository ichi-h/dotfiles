{
  config,
  lib,
  pkgs,
  vars,
  impurelibs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/k8s/master.nix
  ];

  boot = {
    kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce 24;
    kernelModules = [
      "ceph"
      "rbd"
    ];
    kernelParams = [
      "systemd.unified_cgroup_hierarchy=1"
      "cgroup_enable=memory"
    ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb"
      "reset-raspberrypi"
      "bcm_phy_lib"
      "broadcom"
      "mdio_bcm_unimac"
    ];
    loader = {
      systemd-boot.enable = true;
    };
  };

  networking = {
    hostName = "yomogi"; # Define your hostname.
    networkmanager.unmanaged = [ "enabcm6e4ei0" ];
    interfaces.enabcm6e4ei0 = {
      ipv4.addresses = [
        {
          address = impurelibs.secrets.ip-address-yomogi.private;
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = vars.default-gateway;
    nameservers = [
      vars.default-gateway
      "8.8.8.8"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  users.users."${impurelibs.secrets.username}".hashedPassword =
    impurelibs.secrets.hashed-user-passwd-yomogi;
}
