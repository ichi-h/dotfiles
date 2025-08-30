{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      hackgen-font
      hackgen-nf-font
      source-han-code-jp
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
        sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
        monospace = ["Source Han Code JP" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
