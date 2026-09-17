# ~/.config/shell/functions.sh - Funciones compartidas para Bash y Zsh

# Páginas de manual coloreadas con bat
man() {
  if command -v col >/dev/null 2>&1 && command -v bat >/dev/null 2>&1; then
    /usr/bin/man "$@" | col -bx | bat -l man -p --wrap=never
  else
    /usr/bin/man "$@"
  fi
}

# Explorador interactivo con eza, fzf y bat
fp() {
  export EZA_COLORS="op=0:da=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:sn=0:sb=0:df=0:ds=0:uu=0:gu=0:un=0:gn=0:lc=0:ga=0:gm=0:gd=0:gv=0:gt=0:xx=0"

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

    if [ -n "$ZSH_VERSION" ]; then
      [[ -n "$terminfo[smkx]" ]] && echoti smkx
    else
      tput smkx 2>/dev/null
    fi

    eza -lag --git --octal-permissions --header --group-directories-first --time-style=long-iso --color=always $eza_target | \
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
          bat --color=always --style=numbers --line-range :500 "$item" 2>/dev/null || \
          cat "$item" 2>/dev/null
        fi
      ' --preview-window 'right:60%'

    if [ -n "$ZSH_VERSION" ]; then
      [[ -n "$terminfo[rmkx]" ]] && echoti rmkx
    else
      tput rmkx 2>/dev/null
    fi
  )
}

# Conversor de Markdown a PDF ultrarrápido con Pandoc + Typst
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
        output="$2"
        shift 2
        ;;
      -f|--font)
        font="$2"
        shift 2
        ;;
      -s|--size)
        fontsize="$2"
        shift 2
        ;;
      *)
        extra_args+=("$1")
        shift
        ;;
    esac
  done

  pandoc "$input" -o "$output" \
    --pdf-engine=typst \
    -V mainfont="$font" \
    -V fontsize="$fontsize" \
    -V margin-x=2cm \
    -V margin-y=2.5cm \
    -V papersize=a4 \
    "${extra_args[@]}"

  echo "✓ PDF generado en <0.2s: $output (Fuente: $font, $fontsize)"
}
