# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# User bin path (needed for all shells, interactive and non-interactive login)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# --- Historial en tiempo real ---
HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s cmdhist
shopt -s lithist
HISTSIZE=2000
HISTFILESIZE=5000
export PROMPT_COMMAND="history -a; history -c; history -r${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# --- Autocompletado del sistema (bash-completion) ---
if ! shopt -oq posix; then
  if [ -r /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -r /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Navegación de completado con TAB tipo menú
bind "TAB:menu-complete" 2>/dev/null
bind "set show-all-if-ambiguous on" 2>/dev/null

# --- Carga modular de usuario (~/.config/shell/) ---
for config in "$HOME/.config/shell/"*.sh; do
  [ -r "$config" ] && source "$config"
done
unset config
