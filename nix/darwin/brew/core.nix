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
    ];
    casks = [
      "visual-studio-code"
      "font-hackgen-nerd"
      "google-japanese-ime"
      "sequel-ace"
      "clipy"
      "gimp"
      "vivaldi"
      "beekeeper-studio"
      "firefox"
      "karabiner-elements"
      "middleclick"
    ];
  };
}
