# dotfiles

## Usage

```sh
git clone https://github.com/ichi-h/dotfiles

cd dotfiles
cp .env.sample .env
vim .env # update .env

home-manager switch --flake .#linux

tmux
tmux source ~/.tmux.conf # or press prefix + I
```
