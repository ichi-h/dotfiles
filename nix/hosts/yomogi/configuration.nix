{ config, pkgs, vars, impurelibs, ... }:
{
  imports = [
    ../../modules/base
    ../../modules/coredns
    ../../modules/k8s/master.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    kernelModules = [ "ceph" ];
    kernelParams = [
      "systemd.unified_cgroup_hierarchy=1"
      "cgroup_enable=memory"
    ];
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  networking = {
    hostName = "yomogi"; # Define your hostname.
    networkmanager.unmanaged = [ "end0" ];
    interfaces.end0 = {
      ipv4.addresses = [{
        address = impurelibs.secrets.ip-address-yomogi.private;
        prefixLength = 24;
      }];
    };
  };

  hardware.enableRedistributableFirmware = true;

  users.users."${vars.username}".hashedPassword = impurelibs.secrets.hashed-user-passwd-yomogi;
}
