{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        tokiwa = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            impurelibs = import ./impurelibs;
          };
          modules = [
            ./hosts/tokiwa/configuration.nix
          ];
        };

        hanaakari = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            impurelibs = import ./impurelibs;
          };
          modules = [
            ./hosts/hanaakari/configuration.nix
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
