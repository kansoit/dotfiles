# ~/.bashrc - Configuración de Bash para RHEL / Rocky / Fedora (Modular y sin dependencias de Arch)
# shellcheck shell=bash

# Si la sesión no es interactiva, no ejecutar nada
case $- in
  *i*) ;;
  *) return ;;
esac

# User bin path (seguro y aditivo)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# --- Historial en tiempo real ---
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s cmdhist
shopt -s lithist
HISTSIZE=2000
HISTFILESIZE=5000
export PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Actualizar tamaño de ventana tras cada comando
shopt -s checkwinsize

# lesspipe para previsualizar archivos no-texto (si está presente)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# --- Autocompletado del sistema (bash-completion en RHEL/Fedora) ---
if ! shopt -oq posix; then
  if [ -r /usr/share/bash-completion/bash_completion ]; then
    # shellcheck source=/dev/null
    source /usr/share/bash-completion/bash_completion
  elif [ -r /etc/profile.d/bash_completion.sh ]; then
    # shellcheck source=/dev/null
    source /etc/profile.d/bash_completion.sh
  elif [ -r /etc/bash_completion ]; then
    # shellcheck source=/dev/null
    source /etc/bash_completion
  fi
fi

# Navegación de completado con TAB tipo menú
bind "TAB:menu-complete" 2>/dev/null
bind "set show-all-if-ambiguous on" 2>/dev/null

# --- Carga modular de usuario (~/.config/shell/) ---
for config in "$HOME/.config/shell/"*.sh; do
  # shellcheck source=/dev/null
  [ -r "$config" ] && source "$config"
done
unset config

# --- Integraciones modernas (Mise, Starship, Zoxide) ---
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

if [[ ${TERM:-} != "dumb" ]] && command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"
  eval "$(starship init bash)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi
