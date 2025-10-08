# dotfiles

## Hosts

| Machine               | Hostname                      | OS         | Kubernetes Role | CPU/GPU                                        | RAM  | Storage                                  |
| --------------------- | ----------------------------- | ---------- | --------------- | ---------------------------------------------- | ---- | ---------------------------------------- |
| **Raspberry Pi 4**    | **yomogi<br>（蓬）**          | NixOS      | Control Plane   | ARM Cortex-A72                                 | 4GB  | 64GB（SD Card）                          |
| **Mini PC 1**         | **tokiwa<br>（常磐）**        | NixOS      | Worker          | Intel N97                                      | 16GB | 512GB（M.2 SSD）                         |
| **Mini PC 2**         | **hanaakari<br>（花明かり）** | NixOS      | Worker          | Intel N97                                      | 16GB | 512GB（M.2 SSD）<br>1 TB（External SSD） |
| **Dev Server**        | **shiosai<br>（潮騒）**       | Arch Linux | -               | Intel Core i5-13400                            | 32GB | 1 TB（M.2 SSD）                          |
| **Windows PC（WSL）** | **fujibakama<br>（藤袴）**    | NixOS      | -               | Intel Core i5-12600K + NVIDIA GeForce RTX 5070 | 32GB | 1 TB x 2（M.2 SSD）                      |

## Setup

Install Nix beforehand, and NixOS if necessary.

- [Nix Installer](https://github.com/DeterminateSystems/nix-installer)

```sh
cd ~/
git clone https://github.com/ichi-h/dotfiles
cd dotfiles
```
