(cat $HOME/.config/wpg/sequences &)
export TERM="xterm-256color"

HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
#bindkey "-v

function zle-line-init {
  powerlevel9k_prepare_prompts
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  zle reset-prompt
  zle -R
}

function zle-line-finish {
  powerlevel9k_prepare_prompts
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi
  zle reset-prompt
  zle -R
}

function zle-keymap-select {
  powerlevel9k_prepare_prompts
  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N ale-line-finish
zle -N zle-keymap-select
export KEYTIMEOUT=1

# The following lines were added by compinstall
zstyle :compinstall filename '/home/jasperro/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=enabled
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Powerlevel9k Configuration
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_COLOR_SCHEME='dark'
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true

POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_beginning"

POWERLEVEL9K_RVM_BACKGROUND="black"
POWERLEVEL9K_RVM_FOREGROUND="249"
POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_RVM_BACKGROUND="black"
POWERLEVEL9K_RVM_FOREGROUND="249"
POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR="red"

POWERLEVEL9K_TIME_BACKGROUND="blue"
POWERLEVEL9K_TIME_FORMAT="  %D{%H:%M}"

POWERLEVEL9K_FOLDER_ICON='  '
POWERLEVEL9K_HOME_ICON='  '
POWERLEVEL9K_HOME_SUB_ICON='  '
POWERLEVEL9K_EXECUTION_TIME_ICON=' '
POWERLEVEL9K_BATTERY_ICON=' '
POWERLEVEL9K_TIME_ICON='Time'
POWERLEVEL9K_OS_ICON='ArchLinux'

POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='black'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='blue'

POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'
POWERLEVEL9K_VCS_COMMIT_ICON="\uf417"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='green'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='white'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='black'

#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode context ssh root_indicator dir vcs)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context ssh root_indicator dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status rvm time)
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{black}█"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}█ %F{white}"

POWERLEVEL9K_VI_INSERT_MODE_STRING=""
POWERLEVEL9K_VI_COMMAND_MODE_STRING=""

# Zsh syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases and functions
alias ls='ls --color=always'
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CFlh'
alias pac='yay'
alias remorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias '_'='sudo'
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
