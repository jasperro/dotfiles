# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; then
  bindkey "^[[1~" beginning-of-line
  bindkey "^[[4~" end-of-line
else
  bindkey "^[[H" beginning-of-line
  bindkey "^[[F" end-of-line
fi

(cat $HOME/.config/wpg/sequences &)
#export TERM="xterm-256color"
export TERM="kitty"
source ~/.fonts/fontawesome-regular.sh
source ~/.fonts/devicons-regular.sh
source ~/.fonts/octicons-regular.sh
source ~/.fonts/pomicons-regular.sh

HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=20000
#bindkey "-v

export KEYTIMEOUT=1

source /usr/share/fonts/awesome-terminal-fonts/*.sh

# The following lines were added by compinstall
zstyle :compinstall filename '/home/jasperro/.zshrc'
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# End of lines added by compinstall

# Autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=enabled
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases and functions
#alias ls='ls --color=always'
alias ls='exa --icons'
alias la='ls -la'
alias lg='la --git'
alias l='ls -Flh'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gr='git clean -fdx && git reset --hard'
alias pac='yay'
alias bgr='setsid'
alias siz='du -hs'
alias ':q'='exit'
alias remorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias pkglist="pacman --query --quiet --explicit --native | sed ':a;N;\$!ba;s/\n/ /g'"
alias '_'='sudo'
alias protoncli='STEAM_COMPAT_DATA_PATH=~/.wine/ ~/.steam/steam/steamapps/common/Proton\ 4.11/proton'

setopt autocd
setopt correct
setopt histignoredups
setopt rcquotes

mcd () {
    mkdir -p $1
    cd $1
}
up() { cd $(eval printf '../'%.0s {1..$1}) && echo Went up $1 to $(pwd); }
c() {
cd $1 && ls
}

export GOPATH="$HOME/go"
export PATH=$GOPATH/bin/:$HOME/.local/bin:$HOME/.yarn/bin:$PATH

# Keybindings
bindkey "^[[2~" overwrite-mode
bindkey "^[OH" beginning-of-line
bindkey "^[[5~" up-line-or-history
bindkey "^[[3~" delete-char
bindkey "^[OF" end-of-line
bindkey "^[[6~" down-line-or-history
bindkey "^[OA" history-beginning-search-backward
bindkey "^[OB" history-beginning-search-forward

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
