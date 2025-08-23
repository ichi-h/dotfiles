# dotfiles

Install Nix and Home Manager in advance.

- [Nix Installer](https://github.com/DeterminateSystems/nix-installer)
- [Home Manager](https://nix-community.github.io/home-manager)

## Usage

```sh
cd ~/
git clone https://github.com/ichi-h/dotfiles

cd dotfiles
cp .env.sample .env
vim .env # edit .env

# For Linux
home-manager switch --flake .#linux

# For Darwin
home-manager switch --flake .#darwin
```
