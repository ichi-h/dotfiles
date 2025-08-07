# dotfiles

## Usage

```sh
git clone https://github.com/ichi-h/dotfiles

cd dotfiles
cp .env.sample .env
vim .env # update .env

# For Linux
home-manager switch --flake .#linux

# For Darwin
home-manager switch --flake .#darwin
```
