#!/usr/bin/env bash
# Bootstrap dotfiles via GNU stow.
#
# Usage:
#   ./install.sh               # stow all packages
#   ./install.sh nvim fish     # stow only listed packages
#   ./install.sh -D            # unstow all packages
#   ./install.sh -D nvim       # unstow listed packages
#   ./install.sh -n            # dry-run (stow --no, just show what would happen)

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${HOME}"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

ALL_PACKAGES=(
  alacritty
  btop
  fish
  git
  gtk
  ideavim
  kitty
  micro
  niri
  noctalia
  nvim
  shell
  shelly
  starship
  tealdeer
  zathura
  zed
)

STOW_FLAGS=()
ACTION="stow"

while [[ $# -gt 0 ]] && [[ "$1" == -* ]]; do
  case "$1" in
    -D|--delete) ACTION="unstow"; shift ;;
    -n|--no)     STOW_FLAGS+=("--no"); shift ;;
    -h|--help)   sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "unknown flag: $1" >&2; exit 1 ;;
  esac
done

if [[ $# -gt 0 ]]; then
  PACKAGES=("$@")
else
  PACKAGES=("${ALL_PACKAGES[@]}")
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "stow is not installed. Install it first: sudo pacman -S stow" >&2
  exit 1
fi

backup_conflicts() {
  local pkg="$1"
  local moved=0
  while IFS= read -r -d '' file; do
    local rel="${file#$DOTFILES_DIR/$pkg/}"
    local target="$TARGET/$rel"
    if [[ -L "$target" ]]; then
      rm -- "$target"
    elif [[ -e "$target" ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv -- "$target" "$BACKUP_DIR/$rel"
      moved=1
    fi
  done < <(find "$DOTFILES_DIR/$pkg" \( -type f -o -type l \) -print0)
  [[ $moved -eq 1 ]] && echo "  ↳ backed up existing files to $BACKUP_DIR"
}

for pkg in "${PACKAGES[@]}"; do
  if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
    echo "skip: package '$pkg' not found"
    continue
  fi

  if [[ "$ACTION" == "unstow" ]]; then
    echo "→ unstow $pkg"
    stow "${STOW_FLAGS[@]}" -d "$DOTFILES_DIR" -t "$TARGET" -D "$pkg"
  else
    echo "→ stow $pkg"
    backup_conflicts "$pkg"
    stow "${STOW_FLAGS[@]}" -d "$DOTFILES_DIR" -t "$TARGET" -R "$pkg"
  fi
done

echo
echo "Done."
[[ -d "$BACKUP_DIR" ]] && echo "Replaced files were backed up to: $BACKUP_DIR"
