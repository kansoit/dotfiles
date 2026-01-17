# ~/.bashrc: executed by bash(1) for non-login shells.
# shellcheck shell=bash
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
shopt -s lithist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Sincronización de historial en tiempo real
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    (xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    # shellcheck disable=SC2015
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -halF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
# long command; alert

# Definir "alert" solo si hay entorno gráfico (X11 o Wayland)
if command -v notify-send >/dev/null 2>&1 && { [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; }; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" \
    "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    # shellcheck source=/dev/null
    . ~/.bash_aliases
fi

alias mkdir='mkdir -pv'
alias df='df -Th'

if command -v trash &> /dev/null 2>&1; then
  alias rm='trash'
fi

if command -v microk8s &> /dev/null 2>&1; then
  alias kubectl='microk8s kubectl'
fi

if command -v fzf &> /dev/null 2>&1; then
  alias hts="history | fzf --tac"
fi

alias ht="history"

if command -v fdfind &> /dev/null 2>&1; then
  alias fd=fdfind
fi

if command -v micro &> /dev/null 2>&1; then
  alias m=micro
fi

if command -v git > /dev/null 2>&1; then
    # Estado y Log (Visuales)
    alias gst='git status -sb'
    alias gl='git log --oneline --graph --decorate --all'

    # Flujo de cambios
    alias ga='git add'
    alias gaa='git add -A'
    alias gd='git diff'

    # Commits
    alias gc='git commit'
    alias gcm='git commit -m'
    alias gca='git commit --amend'

    # Ramas y Navegación
    alias gb='git branch'
    alias gco='git checkout'
    alias gsw='git switch'

    # Sincronización
    alias gp='git push'
    alias gpl='git pull'

    # Utilidad
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

# Configuración de fzf y fd
if command -v fzf &> /dev/null 2>&1 && command -v fd &> /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi

# Alias para eza
if command -v eza >/dev/null 2>&1; then
    alias el='EZA_COLORS="op=0:da=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:sn=0:sb=0:df=0:ds=0:uu=0:gu=0:un=0:gn=0:lc=0:ga=0:gm=0:gd=0:gv=0:gt=0:xx=0" eza -lag --git --octal-permissions --header --group-directories-first --time-style=long-iso'
fi

# Lógica para alias universal bcat
if command -v batcat &> /dev/null; then
    # Caso Debian/Ubuntu
    alias bcat='batcat -p'
elif command -v bat &> /dev/null; then
    # Caso Fedora/RedHat
    alias bcat='bat -p'
fi

fp() {
    EZA_COLORS="op=0:da=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:sn=0:sb=0:df=0:ds=0:uu=0:gu=0:un=0:gn=0:lc=0:ga=0:gm=0:gd=0:gv=0:gt=0:xx=0" \
    eza -lag --git --octal-permissions --header --group-directories-first --time-style=long-iso --color=always | \
    fzf --ansi \
        --header-lines=1 \
        --layout=reverse \
        --height=95% \
        --border \
        --inline-info \
        --preview '
            # shellcheck disable=SC2016
            item=$(echo {9..})
            if [ -d "$item" ]; then
                eza --tree --color=always --icons "$item" 2>/dev/null | head -200
            else
                batcat --color=always --style=numbers --line-range :500 "$item" 2>/dev/null || \
                bat --color=always --style=numbers --line-range :500 "$item" 2>/dev/null || \
                cat "$item" 2>/dev/null
            fi
        ' --preview-window 'right:60%'
}

# Configurar nano como editor por defecto, solo si está instalado
if command -v nano >/dev/null 2>&1; then
    export EDITOR=nano
    export VISUAL=nano
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    # shellcheck source=/dev/null
    . /etc/bash_completion
  fi
fi

bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"

# PATH aditivo (no pisa rutas previas del sistema)
export PATH="$HOME/.local/bin:/snap/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export LIBVIRT_DEFAULT_URI='qemu:///system'

if command -v terraform > /dev/null 2>&1; then
    complete -C /usr/bin/terraform terraform
fi

# --- Node Version Manager (NVM) ---
export NVM_DIR="$HOME/.nvm"

# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if command -v starship &> /dev/null 2>&1; then
  export STARSHIP_CONFIG=${HOME}/.config/starship.toml
  eval "$(starship init bash)"
fi

if command -v zoxide &> /dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi
