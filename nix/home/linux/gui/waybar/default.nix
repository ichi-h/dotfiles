{
  programs.waybar = {
    enable = true;
  };
  home.file = {
    ".config/waybar/config.jsonc".source = ./config.jsonc;
    ".config/waybar/modules.json".source = ./modules.json;
    ".config/waybar/style.css".source = ./style.css;
  };
}
