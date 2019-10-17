cat $HOME/.config/wpg/sequences &
alias pac='yay'
alias remorphans='sudo pacman -Rns (pacman -Qtdq)'
alias pkglist="pacman --query --quiet --explicit --native | sed ':a;N;\$!ba;s/\n/ /g'"
alias '_'='sudo'
alias protoncli='STEAM_COMPAT_DATA_PATH=~/wineprefix/ ~/.steam/steam/steamapps/common/Proton\ 4.2/proton'

set -x PATH "$HOME/node_modules/bin:$PATH"
set -x npm_config_prefix "~/.node_modules"
set -x GOPATH "$HOME/go"
set -x _JAVA_AWT_WM_NONREPARENTING 1
set -x PATH $PATH:$GOPATH/bin/
