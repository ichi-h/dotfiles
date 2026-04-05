{ vars, impurelibs, mcp-servers-nix, ... }:
{
  imports = [
    ../../modules/darwin/core.nix
    ../../modules/darwin/brew/core.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${vars.username} = import ../../home/darwin/home.nix;
    extraSpecialArgs = { inherit vars impurelibs mcp-servers-nix; };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
