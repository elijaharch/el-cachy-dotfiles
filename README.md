# cachy-dots


## Installation

```bash
sudo pacman -S stow

git clone git@github.com:nerfthisdev/<repo>.git ~/dotfiles
cd ~/dotfiles

./install.sh

#just these
./install.sh nvim fish kitty
```

## Usage

```bash
./install.sh              # развернуть всё
./install.sh nvim fish    # развернуть выбранные пакеты
./install.sh -n           # dry-run: показать что произойдёт, ничего не менять
./install.sh -D           # снять все симлинки
./install.sh -D nvim      # снять конкретный пакет
```


## Create dots for new app

1. Make pkg with`$HOME` structure:
   ```bash
   mkdir -p ~/dotfiles/newapp/.config/newapp
   mv ~/.config/newapp/* ~/dotfiles/newapp/.config/newapp/
   ```
2. Add to `ALL_PACKAGES` in `install.sh`.
3. Install:
   ```bash
   ./install.sh newapp
   ```

