{ ... }:
{
  homebrew = {
    enable = true;
    brews = [
      "ca-certificates"
      "ffmpeg"
      "openssl@3"
      "wakeonlan"
      "colima"
      "docker"
      "docker-compose"
      "awscli"
    ];
    casks = [
      "iterm2"
      "visual-studio-code"
      "font-hackgen-nerd"
      "font-source-han-code-jp"
      "google-japanese-ime"
      "sequel-ace"
      "clipy"
      "gimp"
      "vivaldi"
      "beekeeper-studio"
      "firefox"
      "karabiner-elements"
      "middleclick"
      "obs"
      "cmux"
    ];
  };
}
