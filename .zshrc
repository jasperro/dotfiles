# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

(cat $HOME/.config/wpg/sequences &)
export TERM="xterm-256color"
source ~/.fonts/fontawesome-regular.sh
source ~/.fonts/devicons-regular.sh
source ~/.fonts/octicons-regular.sh
source ~/.fonts/pomicons-regular.sh

HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
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
alias ls='ls --color=always'
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CFlh'
alias pac='yay'
alias remorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias pkglist="pacman --query --quiet --explicit --native | sed ':a;N;\$!ba;s/\n/ /g'"
alias '_'='sudo'
alias protoncli='STEAM_COMPAT_DATA_PATH=~/wineprefix/ ~/.steam/steam/steamapps/common/Proton\ 4.2/proton'
mcd () {
    mkdir -p $1
    cd $1
}
wgsh () {
	sh -c "$(curl -fsSL $1)"
}
up() { cd $(eval printf '../'%.0s {1..$1}) && echo Went up $1 to $(pwd); }
cl() {
cd $1 && ls
}

export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin/

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
