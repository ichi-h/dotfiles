{
  description = "home-server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (final: prev: rec {
            kubernetes-helm-wrapped = prev.wrapHelm prev.kubernetes-helm {
              plugins = with prev.kubernetes-helmPlugins; [
                helm-diff
              ];
            };
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            kind
            kubectl
            kubernetes-helm-wrapped
            helmfile-wrapped
          ];
          shellHook = ''
            if ! kind get clusters | grep -q '^kind$'; then
              echo "Creating kind cluster..."
              kind create cluster --config kind-config.yaml
            else
              echo "Kind cluster 'kind' already exists."
            fi
          '';
        };
      }
    );
}
