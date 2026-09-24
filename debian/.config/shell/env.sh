# ~/.config/shell/env.sh - Variables de entorno compartidas para Bash y Zsh en Debian / Ubuntu
# shellcheck shell=sh

# PATH del usuario (aditivo, seguro y sin duplicaciones)
for dir in "$HOME/.local/bin" "/snap/bin" "/usr/local/bin" "/usr/local/sbin"; do
  if [ -d "$dir" ]; then
    case ":$PATH:" in
      *":$dir:"*) ;;
      *) export PATH="$dir:$PATH" ;;
    esac
  fi
done

# Libvirt / QEMU
export LIBVIRT_DEFAULT_URI='qemu:///system'

# FZF con fd / fdfind por defecto (Debian empaqueta fd como fdfind)
if command -v fdfind >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fdfind --type f'
elif command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi

# Editor por defecto
if command -v micro >/dev/null 2>&1; then
  export EDITOR=micro
  export VISUAL=micro
elif command -v nano >/dev/null 2>&1; then
  export EDITOR=nano
  export VISUAL=nano
fi

# Colores para compilador GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
fi
if [ -n "${BASH_VERSION:-}" ] && [ -s "$NVM_DIR/bash_completion" ]; then
  # shellcheck source=/dev/null
  . "$NVM_DIR/bash_completion"
fi
