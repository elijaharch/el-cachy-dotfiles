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
  local pkg_dir="$DOTFILES_DIR/$pkg"
  local moved=0
  # 1. Move conflicting files / replace stale symlinks.
  #    Skip anything whose path resolves back into our own package —
  #    otherwise `mv` would follow a parent symlink (e.g. ~/.config/gtk-3.0
  #    -> dotfiles/gtk/.config/gtk-3.0) and eat the package's real files.
  while IFS= read -r -d '' file; do
    local rel="${file#$pkg_dir/}"
    local target="$TARGET/$rel"
    local resolved
    resolved=$(readlink -f -- "$target" 2>/dev/null || true)
    if [[ -n "$resolved" && "$resolved" == "$pkg_dir"/* ]]; then
      continue
    fi
    if [[ -L "$target" ]]; then
      rm -- "$target"
    elif [[ -e "$target" ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv -- "$target" "$BACKUP_DIR/$rel"
      moved=1
    fi
  done < <(find "$pkg_dir" \( -type f -o -type l \) -print0)

  # 2. Remove empty target directories left behind, so stow can
  #    "fold" a whole subtree into a single symlink-on-directory.
  #    Skip shared parent dirs (.config, .local, ...) — they belong to
  #    multiple packages and should never be removed by us.
  while IFS= read -r -d '' dir; do
    [[ "$dir" == "$DOTFILES_DIR/$pkg" ]] && continue
    local rel="${dir#$DOTFILES_DIR/$pkg/}"
    case "$rel" in
      .|.config|.local|.local/share|.local/state|.local/bin|.cache|.ssh|.gnupg) continue ;;
    esac
    local target="$TARGET/$rel"
    if [[ -d "$target" && ! -L "$target" ]]; then
      rmdir --ignore-fail-on-non-empty -- "$target" 2>/dev/null || true
    fi
  done < <(find "$DOTFILES_DIR/$pkg" -depth -type d -print0)

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
