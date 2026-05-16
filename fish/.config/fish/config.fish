# ~/.config/fish/config.fish
# ---------------------------------
# Modular config load — fish edition
# ---------------------------------
scheme set tomorrow-night
set fish_greeting

set fish_cursor_default block


set -gx EDITOR nvim
set -gx ZSH $HOME/.oh-my-zsh        # kept for reference; unused in fish
set -gx BUN_INSTALL $HOME/.bun
set -gx SDKMAN_DIR $HOME/.sdkman

fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $BUN_INSTALL/bin
fish_add_path /home/nerfthisdev/.spicetify
fish_add_path $HOME/.local/share/nvim/mason/bin/
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin


abbr -a c  'clear'
abbr -a codex 'ALL_PROXY="socks5://127.0.0.1:2080" codex'
abbr -a ssh 'kitten ssh'
abbr -a ll 'eza -lh'
abbr -a l  'eza -lah'
abbr -a lg 'lazygit'
abbr -a mvim 'NVIM_APPNAME=nvim-minimax nvim'
abbr -a top 'btop'

if status is-interactive
    # Commands to run in interactive sessions can go here
end


if type -q zoxide
  zoxide init fish | source
end

starship init fish | source

# быстрые команды для управления zapret
alias zapret-config='$HOME/zapret-configs/install.sh'
alias zapret-utils='$HOME/zapret-configs/utils-zapret.sh'
alias zapret-utils='$HOME/zapret-configs/utils-zapret.sh'
