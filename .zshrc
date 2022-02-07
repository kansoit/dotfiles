# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

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


# # End of lines configured by zsh-newuser-install
# # The following lines were added by compinstall
# zstyle :compinstall filename '~.zshrc'
zstyle :compinstall filename '/home/horacio/.zshrc'
autoload -Uz compinit
compinit
_comp_options+=(globdots)

alias ls="ls --color=auto"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Allow for command substitution in PS1 to have a common prompt with bash
setopt promptsubst
# Append to history to avoid losing commands when multiple shells are open
setopt appendhistory
# Show an error when a globbing expansion doesn't find any match
setopt nomatch
# List on ambiguous completion and Insert first match immediately
setopt autolist menucomplete
# Don't add duplicates nor commands starting with a space to the history
setopt histignoredups histignorespace
# Use pushd when cd-ing around
setopt autopushd pushdminus pushdsilent
# Use single quotes in string without the weird escape tricks
setopt rcquotes
# Single word commands can resume an existing job
setopt autoresume
# Those options aren't wanted
unsetopt autocd beep extendedglob notify


# Prompt
PROMPT='%B%F{green}%n@%m%F{white}:%B%F{blue}%d%F{white}$%b '

source ~/.zsh/zsh-autosuggestions.zsh
source ~/.zsh/zsh-history-substring-search.zsh
fpath=(~/.zsh/zsh-completions/src $fpath)

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

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

eval "$(starship init zsh)"
