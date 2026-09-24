# ~/.config/shell/aliases.sh - Alias compartidos para Bash y Zsh en RHEL / Rocky / Fedora
# shellcheck shell=sh

# --- Sistema y Navegación Básica ---
alias mkdir='mkdir -pv'
alias df='df -Th'
alias c='clear'
alias sudo='sudo '

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Gestor de Paquetes DNF / RPM (RHEL / Rocky / Fedora) ---
if command -v dnf >/dev/null 2>&1; then
  alias dnfi='sudo dnf install'
  alias dnfs='dnf search'
  alias dnfu='sudo dnf upgrade --refresh'
  alias dnfrem='sudo dnf remove'
  alias dnfc='sudo dnf clean all'
  alias dnfl='dnf list --installed'
fi

# --- Bat (Nativo en RHEL / Fedora) ---
_BAT_BIN=""
if command -v bat >/dev/null 2>&1; then
  _BAT_BIN="bat"
elif command -v batcat >/dev/null 2>&1; then
  _BAT_BIN="batcat"
fi

if [ -n "$_BAT_BIN" ]; then
  # shellcheck disable=SC2139
  alias bcat="$_BAT_BIN -p -p"
fi

# --- Eza (Modern ls con iconos y git) ---
if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
  alias tree='eza --tree -a --icons=auto'
  alias etree='eza --tree -a --icons=auto'
  alias el='EZA_COLORS="op=0:da=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:sn=0:sb=0:df=0:ds=0:uu=0:gu=0:un=0:gn=0:lc=0:ga=0:gm=0:gd=0:gv=0:gt=0:xx=0" eza -lag --git --octal-permissions --header --group-directories-first --time-style=long-iso'
fi

# --- Editor Micro ---
if command -v micro >/dev/null 2>&1; then
  alias m=micro
fi

# --- Papelera segura (trash-cli) ---
if command -v trash >/dev/null 2>&1; then
  alias rm='trash'
  alias tlist='trash-list'
  alias trest='trash-restore'
  alias tcln='trash-empty'
fi

# --- Uso de disco interactivo (dua / ncdu) ---
if command -v dua >/dev/null 2>&1; then
  alias dua='dua i'
  alias duai='sudo dua i / -i /mnt'
  alias ncdu='sudo dua i / -i /mnt'
fi

# --- Monitor de rendimiento nmon ---
if command -v nmon >/dev/null 2>&1; then
  if command -v ghostty >/dev/null 2>&1; then
    alias nmon='ghostty --font-size=10 -e env NMON=cdnm nmon >/dev/null 2>&1 &'
  else
    alias nmon='env NMON=cdnm nmon'
  fi
fi

# --- Historial interactivo ---
if [ -n "${ZSH_VERSION:-}" ]; then
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

# --- Podman (Motor de contenedores estándar en RHEL / Fedora) ---
if command -v podman >/dev/null 2>&1; then
  if [ -n "$_BAT_BIN" ]; then
    # shellcheck disable=SC2139
    alias pvls="podman volume ls | $_BAT_BIN -p -p -l conf"
    # shellcheck disable=SC2139
    alias pnls="podman network ls | $_BAT_BIN -p -p -l conf"
    # shellcheck disable=SC2139
    alias pcls="podman container ls -a | $_BAT_BIN -p -p -l conf"
    # shellcheck disable=SC2139
    alias pils="podman image ls | $_BAT_BIN -p -p -l conf"
  else
    alias pvls="podman volume ls"
    alias pnls="podman network ls"
    alias pcls="podman container ls -a"
    alias pils="podman image ls"
  fi
  alias pimg='podman images'
  alias plog='podman logs'
  alias pcln="podman ps -a --format '{{.Names}}'"
  alias pstp='podman stop'
  alias pstr='podman start'
  alias pcdw="podman-compose down"
  alias pcup="podman-compose up -d"
  alias prmi="podman rmi"
fi

# --- Docker ---
if command -v docker >/dev/null 2>&1; then
  if [ -n "$_BAT_BIN" ]; then
    # shellcheck disable=SC2139
    alias dvls="docker volume ls | $_BAT_BIN -p -p -l conf"
    # shellcheck disable=SC2139
    alias dnls="docker network ls | $_BAT_BIN -p -p -l conf"
    # shellcheck disable=SC2139
    alias dcls="docker container ls -a | $_BAT_BIN -p -p -l conf"
  else
    alias dvls="docker volume ls"
    alias dnls="docker network ls"
    alias dcls="docker container ls -a"
  fi
  alias dils='docker image ls'
  alias dimg='docker images'
  alias dlog='docker logs'
  alias dcln="docker ps -a --format '{{.Names}}'"
  alias dstp='docker stop'
  alias dstr='docker start'
  alias dcdw="docker compose down"
  alias dcup="docker compose up -d"
  alias drmi="docker rmi"
fi

# --- Pre-commit & Linters ---
if command -v pre-commit >/dev/null 2>&1; then
  alias alint='pre-commit run ansible-lint --files'
  alias slint='pre-commit run shellcheck --files'
  alias alint-all='pre-commit run ansible-lint --all-files'
  alias slint-all='pre-commit run shellcheck --all-files'
  alias alint-up='pre-commit autoupdate'
fi

# --- MicroK8s / Kubernetes ---
if command -v microk8s >/dev/null 2>&1; then
  alias kubectl='microk8s kubectl'
  export KUBECONFIG="$HOME/.kube/config"
fi

# --- Red y Diagnóstico ---
if command -v dig >/dev/null 2>&1; then
  alias myip='dig +short txt o-o.myaddr.l.google.com @8.8.8.8 | tr -d "\""'
fi

# --- Notificación de tareas largas (entornos gráficos como Fedora Desktop) ---
if command -v notify-send >/dev/null 2>&1 && { [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; }; then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# --- AS/400 (IBM i) 5250 Emulator (5250ng) ---
if command -v 5250ng >/dev/null 2>&1; then
  alias gn73='(nohup 5250ng -s GN73 --enable-mcp-server --mcp-server-port 9250 >/dev/null 2>&1 &)'
fi
