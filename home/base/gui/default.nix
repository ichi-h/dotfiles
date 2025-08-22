{ enableGuiPkg }:
{
  imports = builtins.map (f: f { inherit enableGuiPkg; }) [
    ./alacritty
  ];
}
