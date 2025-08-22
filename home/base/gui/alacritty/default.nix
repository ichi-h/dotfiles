{ pkgs, enableGuiPkg,... }:
{
  programs.alacritty = {
    enable = enableGuiPkg;
    settings = {
      font = let hackGenNerdConsole = style: {
        family = "HackGenNerd Console";
        inherit style;
      }; in {
        size = 20;
        normal = hackGenNerdConsole "Regular";
        bold = hackGenNerdConsole "Bold";
        italic = hackGenNerdConsole "Italic";
        bold_italic = hackGenNerdConsole "Bold Italic";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      window = {
        decorations = "buttonless";
        opacity = 0.8;
        startup_mode = "SimpleFullscreen";
        padding = {
          x = 5;
          y = 5;
        };
        class = {
          general = "Alacritty";
          instance = "Alacritty";
        };
      };
    };
  };
}
