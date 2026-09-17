# ~/.config/shell/aliases.sh - Alias compartidos para Bash y Zsh

# --- Sistema y Navegación ---
alias mkdir='mkdir -pv'
alias df='df -Th'
alias c='clear'
alias sudo='sudo '

# Papelera segura (trash-cli)
if command -v trash >/dev/null 2>&1; then
  alias rm='trash'
fi

# Editor micro
if command -v micro >/dev/null 2>&1; then
  alias m=micro
fi

# Uso de disco interactivo (dua reemplaza a ncdu)
if command -v dua >/dev/null 2>&1; then
  alias dua='dua i'
  alias duai='sudo dua i / -i /mnt'
  alias ncdu='sudo dua i / -i /mnt'
fi

# --- Historial interactivo ---
if [ -n "$ZSH_VERSION" ]; then
  alias ht="history 1"
  if command -v fzf >/dev/null 2>&1; then
    alias hts="history 1 | fzf --tac"
  fi
else
  alias ht="history"
  if command -v fzf >/dev/null 2>&1; then
    alias hts="history | fzf --tac"
  fi
fi

# --- Navegación rápida ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Eza (Modern ls con iconos) ---
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
  alias tree='eza --tree -a --icons=auto'
  alias etree='eza --tree -a --icons=auto'
  alias el='EZA_COLORS="op=0:da=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:sn=0:sb=0:df=0:ds=0:uu=0:gu=0:un=0:gn=0:lc=0:ga=0:gm=0:gd=0:gv=0:gt=0:xx=0" eza -lag --git --octal-permissions --header --group-directories-first --time-style=long-iso'
fi

# --- Bat ---
if command -v bat >/dev/null 2>&1; then
  alias bcat="bat -p -p"
fi

# --- Git ---
if command -v git >/dev/null 2>&1; then
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

# --- Docker ---
if command -v docker >/dev/null 2>&1; then
  if command -v bat >/dev/null 2>&1; then
    alias dvls="docker volume ls | bat -p -p -l conf"
    alias dnls="docker network ls | bat -p -p -l conf"
    alias dcls="docker container ls -a | bat -p -p -l conf"
  else
    alias dvls="docker volume ls"
    alias dnls="docker network ls"
    alias dcls="docker container ls -a"
  fi
  alias dils='docker image ls'
  alias dcdw="docker compose down"
  alias dcup="docker compose up -d"
  alias drmi="docker rmi"
fi

# --- Notificación al finalizar comandos largos ---
if command -v notify-send >/dev/null 2>&1 && { [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; }; then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# --- LibreOffice en Modo Claro (silenciado y en segundo plano) ---
if command -v libreoffice >/dev/null 2>&1; then
  libre() {
    GTK_THEME=Adwaita:light libreoffice "$@" >/dev/null 2>&1 &
    disown 2>/dev/null || true
  }
fi


