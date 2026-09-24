# ~/.config/shell/functions.sh - Funciones compartidas para Bash y Zsh en RHEL / Rocky / Fedora
# shellcheck shell=bash

# --- Midnight Commander (MC) ---
# Conservar el directorio al salir y evitar acceso a X11 como root.
unalias mc 2>/dev/null || true
mc() {
  if (( EUID == 0 )); then
    set -- -X "$@"
  fi
  # En RHEL / Fedora suele ubicarse en /usr/libexec/mc/
  if [ -r /usr/libexec/mc/mc-wrapper.sh ]; then
    # shellcheck source=/dev/null
    . /usr/libexec/mc/mc-wrapper.sh
  elif [ -r /usr/share/mc/bin/mc-wrapper.sh ]; then
    # shellcheck source=/dev/null
    . /usr/share/mc/bin/mc-wrapper.sh
  elif [ -r /usr/lib/mc/mc-wrapper.sh ]; then
    # shellcheck source=/dev/null
    . /usr/lib/mc/mc-wrapper.sh
  else
    command mc "$@"
  fi
}

# --- Páginas de manual coloreadas con bat ---
man() {
  local bat_cmd=""
  if command -v bat >/dev/null 2>&1; then
    bat_cmd="bat"
  elif command -v batcat >/dev/null 2>&1; then
    bat_cmd="batcat"
  fi

  if command -v col >/dev/null 2>&1 && [ -n "$bat_cmd" ]; then
    /usr/bin/man "$@" | col -bx | "$bat_cmd" -l man -p --wrap=never
  else
    /usr/bin/man "$@"
  fi
}

# --- Explorador interactivo con eza, fzf y bat ---
fp() {
  export EZA_COLORS="op=0:da=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:sn=0:sb=0:df=0:ds=0:uu=0:gu=0:un=0:gn=0:lc=0:ga=0:gm=0:gd=0:gv=0:gt=0:xx=0"

  if ! command -v eza >/dev/null 2>&1 || ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fp requiere eza y fzf."
    return 127
  fi

  local target="${1:-.}"

  if [ ! -e "$target" ]; then
    echo "Error: '$target' no existe."
    return 1
  fi

  (
    if [ -f "$target" ]; then
      cd "$(dirname "$target")" || return
      local eza_target
      eza_target=$(basename "$target")
    else
      cd "$target" || return
      local eza_target=""
    fi

    if [ -n "${ZSH_VERSION:-}" ]; then
      echoti smkx 2>/dev/null || tput smkx 2>/dev/null
    else
      tput smkx 2>/dev/null
    fi

    local eza_args=(-lag --git --octal-permissions --header --group-directories-first
      --time-style=long-iso --color=always)
    [ -n "$eza_target" ] && eza_args+=("$eza_target")

    # shellcheck disable=SC2016
    eza "${eza_args[@]}" | \
    fzf --ansi \
      --header-lines=1 \
      --layout=reverse \
      --height=95% \
      --border \
      --inline-info \
      --preview '
        clean=$(echo {} | sed "s/\x1b\[[0-9;]*[a-zA-Z]//g")
        item=$(echo "$clean" | sed -E "s/.*[0-9]{4}-[0-9]{2}-[0-9]{2} +[0-9]{2}:[0-9]{2} +//")
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          item="${item:3}"
        fi
        item="${item%% -> *}"
        item=$(echo "$item" | sed -E "s/^\x27(.*)\x27$/\1/")

        if [ -d "$item" ]; then
          eza --tree --color=always --icons "$item" 2>/dev/null | head -200
        else
          if command -v bat >/dev/null 2>&1; then
            bat --color=always --style=numbers --line-range :500 "$item" 2>/dev/null || cat "$item" 2>/dev/null
          elif command -v batcat >/dev/null 2>&1; then
            batcat --color=always --style=numbers --line-range :500 "$item" 2>/dev/null || cat "$item" 2>/dev/null
          else
            cat "$item" 2>/dev/null
          fi
        fi
      ' --preview-window 'right:60%'

    if [ -n "${ZSH_VERSION:-}" ]; then
      echoti rmkx 2>/dev/null || tput rmkx 2>/dev/null
    else
      tput rmkx 2>/dev/null
    fi
  )
}

# --- Conversor de Markdown a PDF ultrarrápido con Pandoc + Typst ---
md2pdf() {
  if [ $# -eq 0 ]; then
    echo "Uso: md2pdf entrada.md [-o salida.pdf] [-f 'Fuente'] [-s 'Tamaño'] [opciones pandoc...]"
    return 1
  fi

  local input="$1"
  shift

  if [ ! -f "$input" ]; then
    echo "Error: el archivo '$input' no existe."
    return 1
  fi

  local output="${input%.*}.pdf"
  local font="${PDF_FONT:-Liberation Sans}"
  local fontsize="11pt"
  local extra_args=()

  while [ $# -gt 0 ]; do
    case "$1" in
      -o|--output)
        if [ $# -lt 2 ] || [ -z "$2" ] || [[ "$2" == -* ]]; then
          echo "Error: $1 requiere un archivo de salida."
          return 2
        fi
        output="$2"
        shift 2
        ;;
      -f|--font)
        if [ $# -lt 2 ] || [ -z "$2" ] || [[ "$2" == -* ]]; then
          echo "Error: $1 requiere una fuente."
          return 2
        fi
        font="$2"
        shift 2
        ;;
      -s|--size)
        if [ $# -lt 2 ] || [ -z "$2" ] || [[ "$2" == -* ]]; then
          echo "Error: $1 requiere un tamaño."
          return 2
        fi
        fontsize="$2"
        shift 2
        ;;
      *)
        extra_args+=("$1")
        shift
        ;;
      esac
  done

  if ! command -v pandoc >/dev/null 2>&1 || ! command -v typst >/dev/null 2>&1; then
    echo "Error: md2pdf requiere pandoc y typst."
    return 127
  fi

  if ! pandoc "$input" -o "$output" \
    --pdf-engine=typst \
    -V mainfont="$font" \
    -V fontsize="$fontsize" \
    -V margin-x=2cm \
    -V margin-y=2.5cm \
    -V papersize=a4 \
    "${extra_args[@]}"; then
    echo "Error: no se pudo generar el PDF."
    return 1
  fi

  echo "✓ PDF generado: $output (Fuente: $font, $fontsize)"
}

# --- Navegación inteligente (cd + zoxide) ---
if command -v zoxide >/dev/null 2>&1; then
  alias cd="zd"
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@" 2>/dev/null; then
        echo "Error: Directory not found"
        return 1
      fi

      printf "\U000F17A9 "
      pwd
    fi
  }
fi

# --- Terraform autocompletion (si está instalado) ---
if command -v terraform >/dev/null 2>&1; then
  if [ -n "${BASH_VERSION:-}" ]; then
    complete -C "$(command -v terraform)" terraform
  elif [ -n "${ZSH_VERSION:-}" ]; then
    complete -o nospace -C "$(command -v terraform)" terraform 2>/dev/null || true
  fi
fi

# --- Búsqueda interactiva de comandos (Bash y Zsh) ---
fcmd() {
  if [ -z "$1" ]; then
    echo "Uso: fcmd <término>" >&2
    return 1
  fi

  if [ -n "${ZSH_VERSION:-}" ]; then
    whence -m "*$1*" 2>/dev/null
  else
    compgen -c | grep -i -- "$1" | sort -u
  fi
}
