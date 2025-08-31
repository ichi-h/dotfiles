{
  programs.niri.enable = true;

  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  environment.variables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
