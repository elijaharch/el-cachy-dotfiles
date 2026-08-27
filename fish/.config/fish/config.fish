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

fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $BUN_INSTALL/bin
fish_add_path $HOME/.spicetify
fish_add_path $HOME/.local/share/nvim/mason/bin/
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.spicetify

abbr -a c  'clear'
abbr -a codex 'ALL_PROXY="socks5://127.0.0.1:2080" codex'
abbr -a ssh 'kitten ssh'
abbr -a ll 'eza -lh'
abbr -a l  'eza -lah'
abbr -a lg 'lazygit'
abbr -a mvim 'NVIM_APPNAME=nvim-minimax nvim'
abbr -a top 'btop'
abbr -a v 'nvim'

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

eval "$(fnm env)"

if type -q boring
  boring --shell fish | source
end

fish_add_path /home/el/.spicetify

# Pi
fish_add_path "/home/el/.local/share/pi-node/node-v22.23.2-linux-x64/bin"

if status is-interactive
    atuin init fish | source
end
