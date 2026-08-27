source /usr/share/cachyos-zsh-config/cachyos-config.zsh

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
