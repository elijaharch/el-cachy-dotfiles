# nerfthisdev dotfiles

Личные конфиги на CachyOS + niri/noctalia. Управляется через [GNU stow](https://www.gnu.org/software/stow/).

## Структура

Каждый подкаталог — это **stow-пакет**, повторяющий структуру `$HOME`. Stow создаёт симлинки из `$HOME` в этот репозиторий, поэтому правка симлинка = правка файла в репе.

```
dotfiles/
├── alacritty/.config/alacritty/
├── btop/.config/btop/
├── fish/.config/fish/
├── git/.gitconfig
├── gtk/.config/gtk-3.0/
├── ideavim/.ideavimrc
├── kitty/.config/kitty/
├── micro/.config/micro/
├── niri/.config/niri/
├── noctalia/.config/noctalia/
├── nvim/.config/nvim/
├── shell/{.zshrc,.bashrc,.bash_profile}
├── shelly/.config/shelly/
├── starship/.config/starship.toml
├── tealdeer/.config/tealdeer/
├── zathura/.config/zathura/
└── zed/.config/zed/
```

## Установка

```bash
# зависимости
sudo pacman -S stow

# клон
git clone git@github.com:nerfthisdev/<repo>.git ~/dotfiles
cd ~/dotfiles

# поставить всё (существующие файлы уедут в ~/.dotfiles-backup/<timestamp>/)
./install.sh

# или только нужное
./install.sh nvim fish kitty
```

## Использование

```bash
./install.sh              # развернуть всё
./install.sh nvim fish    # развернуть выбранные пакеты
./install.sh -n           # dry-run: показать что произойдёт, ничего не менять
./install.sh -D           # снять все симлинки
./install.sh -D nvim      # снять конкретный пакет
```

Под капотом — `stow -d ~/dotfiles -t ~ -R <package>`. Флаг `-R` (restow) безопасно пересоздаёт симлинки.

## Как добавить новое приложение

1. Создать пакет с структурой как в `$HOME`:
   ```bash
   mkdir -p ~/dotfiles/newapp/.config/newapp
   mv ~/.config/newapp/* ~/dotfiles/newapp/.config/newapp/
   ```
2. Добавить имя пакета в массив `ALL_PACKAGES` в `install.sh`.
3. Установить:
   ```bash
   ./install.sh newapp
   ```

## Что НЕ хранится в репе

- `~/.wakatime.cfg` — содержит API ключ
- `ncspot/userstate.cbor`, `nekobox/`, `Throne/` — приватные/auth данные
- Runtime state (`fish_variables`, `micro/buffers`, и т.п.) — см. `.gitignore`
