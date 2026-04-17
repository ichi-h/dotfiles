{ vars, impurelibs, mcp-servers-nix, ... }:
{
  imports = [
    ../../modules/darwin/core.nix
    ../../modules/darwin/netskope-ssl.nix
    ../../modules/darwin/brew/core.nix
    ../../modules/darwin/brew/works.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
