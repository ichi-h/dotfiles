# dotfiles

## Hosts

| Server Name             | Responsibility                                              | Hardware                                                       | OS          | Software                                            | Kubernetes Role        |
| ----------------------- | ----------------------------------------------------------- | -------------------------------------------------------------- | ----------- | --------------------------------------------------- | ---------------------- |
| 常磐 (Tokiwa)           | Management and monitoring of the entire home server system. | Mini Computer (N97, RAM 16GB)                                  | NixOS       | Kubernetes Control Plane, Grafana, Loki, Prometheus | Control Plane + Worker |
| 花明 (Hanaakari)        | Hosting of applications provided by home servers.           | Mini Computer (N97, RAM 16GB)                                  | NixOS       | VaultWarden, Seafile, Navidrome                     | Worker                 |
| 夜もすがら (Yomosugara) | Development environment provision.                          | Desktop (Core i5 13400, RAM 32GB)                              | NixOS       | -                                                   | Worker                 |
| 藤袴 (Fujibakama)       | LLM hosting.                                                | Desktop (Core i5 12600K, RTX 5070, RAM 32GB)                   | NixOS (WSL) | Ollama                                              | Worker                 |
| 蓬 (Yomogi)             | Wake on LAN for home servers.                               | Raspberry Pi 4 Model B (Cortex-A72, RAM 4GB, External 1TB SSD) | NixOS       | Power Management Server                             | (Outside the cluster)  |

## Setup

Install Nix beforehand, and NixOS if necessary.

- [Nix Installer](https://github.com/DeterminateSystems/nix-installer)

```sh
cd ~/
git clone https://github.com/ichi-h/dotfiles
cd dotfiles
```
