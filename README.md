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

# For Linux
nix run nixpkgs#home-manager -- switch --flake .#linux

# For Darwin
nix run nixpkgs#home-manager -- switch --flake .#darwin
```
