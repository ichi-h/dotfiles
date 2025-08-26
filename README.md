# dotfiles

Install Nix in advance or use NixOS.

- [Nix Installer](https://github.com/DeterminateSystems/nix-installer)

## Usage

```sh
cd ~/
git clone https://github.com/ichi-h/dotfiles

cd dotfiles
cp .env.sample .env
vim .env # edit .env

# For Linux (x86_64)
nix run nixpkgs#home-manager -- switch --flake .#linux-x86

# For Linux (arm64)
nix run nixpkgs#home-manager -- switch --flake .#linux-arm64

# For Darwin
nix run nixpkgs#home-manager -- switch --flake .#darwin
```

## Hosts

| Server Name             | Responsibility                                              | Hardware                                                       | OS          | Software                                                                     | Kubernetes Role        |
| ----------------------- | ----------------------------------------------------------- | -------------------------------------------------------------- | ----------- | ---------------------------------------------------------------------------- | ---------------------- |
| 常磐 (Tokiwa)           | Management and monitoring of the entire home server system. | Mini Computer (N97, RAM 16GB)                                  | NixOS       | Kubernetes Control Plane, Grafana, Loki, Prometheus, Power Management Server | Control Plane + Worker |
| 花明 (Hanaakari)        | Hosting of applications provided by home servers.           | Mini Computer (N97, RAM 16GB)                                  | NixOS       | VaultWarden                                                                  | Worker                 |
| 蓬 (Yomogi)             | Storage provision.                                          | Raspberry Pi 4 Model B (Cortex-A72, RAM 4GB, External 1TB SSD) | NixOS       | Seafile, Navidrome                                                           | Worker                 |
| 夜もすがら (Yomosugara) | Development environment provision.                          | Desktop (Core i5 13400, RAM 32GB)                              | NixOS       | -                                                                            | Worker                 |
| 藤袴 (Fujibakama)       | LLM hosting.                                                | Desktop (Core i5 12600K, RTX 5070, RAM 32GB)                   | NixOS (WSL) | Ollama                                                                       | Worker                 |
