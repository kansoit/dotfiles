# Lines configured by zsh-newuser-install
# shellcheck shell=bash
# shellcheck disable=SC2034,SC1091
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=5000

bindkey -e

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[H' beginning-of-line      # Tecla Inicio (Home)
bindkey '^[[F' end-of-line            # Tecla Fin (End)
bindkey '^[[3~' delete-char           # Tecla Suprimir (Delete)
bindkey '^?' backward-delete-char     # Tecla Backspace

# Keypad
# 0 . Enter NumPad On/Off
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
bindkey -s "^[OP" ""
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ol" "+"
bindkey -s "^[OS" "-"
bindkey -s "^[OR" "*"
bindkey -s "^[OQ" "/"


fpath=("$HOME/.zsh/zsh-completions" "${fpath[@]}")

autoload -Uz compinit
compinit
_comp_options+=(globdots)

# --- Carga de Plugins desde el HOME ---
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- ALIAS DE SISTEMA (Extraídos de .bashrc) ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -halF'
alias la='ls -A'
alias l='ls -CF'
alias mkdir='mkdir -pv'
alias df='df -Th'
alias c='clear'

# Reemplaza rm por trash (si está instalado)
if command -v trash &> /dev/null 2>&1; then
  alias rm='trash'
fi

# Kubernetes (MicroK8s)
if command -v microk8s &> /dev/null 2>&1; then
  alias kubectl='microk8s kubectl'
fi

# FZF e Historia
if command -v fzf &> /dev/null 2>&1; then
  alias hts="history 1 | fzf --tac"
fi

alias ht="history 1"

# FD (Fix para nombres en Debian/Ubuntu)
if command -v fdfind &> /dev/null 2>&1; then
  alias fd=fdfind
fi

# Editor Micro
if command -v micro &> /dev/null 2>&1; then
  alias m=micro
fi

# --- GIT ALIASES ---
if command -v git > /dev/null 2>&1; then
    alias gst='git status -sb'
    alias gl='git log --oneline --graph --decorate --all'
    alias ga='git add'
    alias gaa='git add -A'
    alias gd='git diff'
    alias gc='git commit'
    alias gcm='git commit -m'
    alias gca='git commit --amend'
    alias gb='git branch'
    alias gco='git checkout'
    alias gsw='git switch'
    alias gp='git push'
    alias gpl='git pull'
    alias gclean='git clean -fd'
fi

if command -v pre-commit > /dev/null 2>&1; then
    alias alint='pre-commit run ansible-lint --files'
    alias slint='pre-commit run shellcheck --files'
    alias alint-all='pre-commit run ansible-lint --all-files'
    alias slint-all='pre-commit run shellcheck --all-files'

    # Opcional: un alias para actualizar los hooks rápidamente
    alias alint-up='pre-commit autoupdate'
fi

# Alias para eza (si está instalado)
if command -v eza >/dev/null 2>&1; then
    alias el='EZA_COLORS="op=0:da=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:sn=0:sb=0:df=0:ds=0:uu=0:gu=0:un=0:gn=0:lc=0:ga=0:gm=0:gd=0:gv=0:gt=0:xx=0" eza -lag --git --octal-permissions --header --group-directories-first --time-style=long-iso'
fi

# --- FUNCIONES ESPECIALES ---

# Alias Alert: Avisa cuando un comando largo termina (Solo si hay entorno gráfico)
if command -v notify-send >/dev/null 2>&1 && { [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; }; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# --- Configuración del Historial ---
# Sincronización en tiempo real (Incluye automáticamente appendhistory e incappendhistory)
setopt sharehistory
# No guarda comandos que empiecen con espacio ni duplicados consecutivos
setopt histignorespace histignoredups

# --- Interfaz y Comportamiento ---
# Permite sustitución de comandos en el PS1 (compatibilidad con prompts de bash)
setopt promptsubst
# Muestra error si un patrón de búsqueda (glob) no encuentra resultados
setopt nomatch
# Menú de completado inteligente con Tab y navegación con flechas
setopt autolist auto_menu
# Manejo de la pila de directorios (permite usar 'cd -')
setopt autopushd pushdminus pushdsilent
# Permite usar comillas simples literales dentro de strings (ej: 'don''t')
setopt rcquotes
# Reanuda procesos suspendidos escribiendo simplemente su nombre
setopt autoresume
# Navegación sin 'cd' y comodines de búsqueda avanzados (recursividad, exclusión)
setopt autocd extendedglob
# Desactiva avisos sonoros y notificaciones de tareas en segundo plano
unsetopt beep notify

# Prompt
PROMPT='%B%F{green}%n@%m%F{white}:%B%F{blue}%d%F{white}$%b '

# Group results by category
zstyle ':completion:*' group-name ''
# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true
## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Use arrow keys in completion list
zstyle ':completion:*' menu select

# Completion formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' menu select

# --- VARIABLES DE ENTORNO ---
export PATH=$HOME/.local/bin:/snap/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LIBVIRT_DEFAULT_URI='qemu:///system'

# --- Node Version Manager (NVM) ---
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


if command -v starship &> /dev/null 2>&1; then
  export STARSHIP_CONFIG=${HOME}/.config/starship.toml
  eval "$(starship init zsh)"
fi

if command -v zoxide &> /dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
