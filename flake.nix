{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      vscode-server,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        ayakashi = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
          };
          modules = [
            ./hosts/ayakashi/configuration.nix
            vscode-server.nixosModules.default
            ({ config, pkgs, ... }: {
              services.vscode-server.enable = true;
            })
          ];
        };
      };

      homeConfigurations = {
        "linux-x86" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            enableGuiPkg = true;
          };
          modules = [ ./home/linux/home.nix ];
        };
        "linux-arm64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            enableGuiPkg = false;
          };
          modules = [ ./home/linux/home.nix ];
        };
        "darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            enableGuiPkg = true;
          };
          modules = [ ./home/darwin/home.nix ];
        };
      };
    };
}
