# ~/.config/shell/env.sh - Variables de entorno compartidas para Bash y Zsh

# Libvirt
export LIBVIRT_DEFAULT_URI='qemu:///system'

# FZF con fd por defecto
if command -v fd >/dev/null 2>&1; then
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

# Colores para GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
