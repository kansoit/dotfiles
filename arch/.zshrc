# ~/.zshrc - Configuración de Zsh integrada con Omarchy / Arch Linux

# --- Bootstrap de entorno Omarchy (Mise, PATH base) ---
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && emulate sh -c 'source /usr/share/omarchy/default/bash/env-bootstrap'

case ":$PATH:" in
  "$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# --- Historial ---
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=5000
setopt sharehistory
setopt histignorespace histignoredups

# --- Completions de Arch y Sistema ---
fpath=(/usr/share/zsh/site-functions $fpath)
autoload -U colors && colors
autoload -Uz compinit && compinit
_comp_options+=(globdots)

# Opciones de comportamiento
setopt promptsubst
setopt nomatch
setopt autolist auto_menu
setopt autopushd pushdminus pushdsilent
setopt rcquotes
setopt autoresume
setopt autocd extendedglob
unsetopt beep notify

# Estilos del menú de autocompletado
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# --- Keybindings (Emacs mode + NumPad) ---
bindkey -e
bindkey '^[[H' beginning-of-line      # Home / Inicio
bindkey '^[[F' end-of-line            # End / Fin
bindkey '^[[3~' delete-char           # Delete / Supr
bindkey '^?' backward-delete-char     # Backspace

# Keypad numérico
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
bindkey -s "^[OP" ""
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
bindkey -s "^[Ol" "+"
bindkey -s "^[OS" "-"
bindkey -s "^[OR" "*"
bindkey -s "^[OQ" "/"

# --- Plugins Oficiales de Arch (/usr/share/zsh/plugins/) ---
# 1. Búsqueda de historial con flechas arriba/abajo
if [[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

# 2. Autosugerencias estilo Fish
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- Integraciones modernas (Mise, Starship, Zoxide) ---
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if [[ ${TERM:-} != "dumb" ]] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# --- Carga modular de usuario (~/.config/shell/) ---
for config in "$HOME/.config/shell/"*.sh; do
  [ -r "$config" ] && source "$config"
done
unset config

# 3. Resaltado de sintaxis (debe cargarse al final de .zshrc)
if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
