# ~/.zshrc - Configuración de Zsh para Debian / Ubuntu (Modular y sin Omarchy)

# User bin path (seguro y aditivo)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# --- Historial ---
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=5000
setopt sharehistory
setopt histignorespace histignoredups

# --- Completions de Zsh ---
# Incluir zsh-completions (clonado por Ansible en ~/.zsh/ o provisto por sistema) ANTES de compinit
if [[ -d "$HOME/.zsh/zsh-completions/src" ]]; then
  fpath=("$HOME/.zsh/zsh-completions/src" $fpath)
fi
[[ -d /usr/share/zsh/vendor-completions ]] && fpath=(/usr/share/zsh/vendor-completions $fpath)
[[ -d /usr/local/share/zsh/site-functions ]] && fpath=(/usr/local/share/zsh/site-functions $fpath)
[[ -d /usr/share/zsh/site-functions ]] && fpath=(/usr/share/zsh/site-functions $fpath)

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
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# --- Keybindings (Emacs mode + NumPad + Edición) ---
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

# --- Plugins de Zsh (Prioridad: ~/.zsh/ gestionado por Ansible, luego /usr/share/) ---
# 1. Búsqueda de historial con flechas arriba/abajo (substring search)
if [[ -r "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
elif [[ -r /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
  source /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh
elif [[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

if (( $+functions[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

# 2. Autosugerencias estilo Fish
if [[ -r "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- Integraciones modernas (Mise, Starship, Zoxide) ---
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if [[ ${TERM:-} != "dumb" ]] && command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"
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

# 3. Resaltado de sintaxis (debe cargarse obligatoriamente al final de .zshrc)
if [[ -r "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
