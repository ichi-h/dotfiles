{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # xremap.url = "github:xremap/nix-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      # xremap,
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
            # xremap.nixosModules.default
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
            # xremap.nixosModules.default
          ];
        };

        yomogi = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            impurelibs = import ./impurelibs;
          };
          modules = [
            ./hosts/yomogi/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "linux-cui-x86" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            mcp-servers-nix = inputs.mcp-servers-nix;
          };
          modules = [ ./home/linux/home-for-cui.nix ];
        };
        "linux-gui-x86" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            mcp-servers-nix = inputs.mcp-servers-nix;
          };
          modules = [ ./home/linux/home-for-gui.nix ];
        };
        "linux-cui-aarch64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            mcp-servers-nix = inputs.mcp-servers-nix;
          };
          modules = [ ./home/linux/home-for-cui.nix ];
        };
        "darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs outputs;
            vars = import ./vars;
            mcp-servers-nix = inputs.mcp-servers-nix;
          };
          modules = [ ./home/darwin/home.nix ];
        };
      };
    };
}
