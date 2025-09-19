{
  networking = {
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";


    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;

    # Enable networking
    networkmanager.enable = true;

    firewall.enable = true;
    firewall.extraCommands = ''
      iptables -A nixos-fw -s 10.0.0.0/8 -j nixos-fw-accept
      iptables -A nixos-fw -s 192.168.10.0/24 -j nixos-fw-accept
    '';
  };
}
