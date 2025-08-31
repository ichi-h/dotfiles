{
  programs.niri.enable = true;

  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  programs.xwayland.enable = true;
  services.xserver.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };
}
