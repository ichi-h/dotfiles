{ enableGuiPkg, ... }:
{
  programs.fuzzel = {
    enable = enableGuiPkg;
  };
}
