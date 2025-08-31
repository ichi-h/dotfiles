{ enableGuiPkg, ... }:
{
  services.hyprpaper.enable = enableGuiPkg;
  services.hyprpaper.settings = {
    ipc = "on";
    splash = false;
    splash_offset = 2.0;

    preload = [ "~/dotfiles/nix/home/linux/gui/hyprpaper/xiirus_aya.jpg" ];
    wallpaper = [ ",~/dotfiles/nix/home/linux/gui/hyprpaper/xiirus_aya.jpg" ];
  };
}
