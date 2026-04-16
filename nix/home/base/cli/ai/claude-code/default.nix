{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-code
  ];

  home.file = {
    ".claude/settings.json".source = ./settings.json;
  };
}
