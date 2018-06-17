#!/bin/sh

eval "$(LC_ALL=C who -T -m | sed -r -e 's|(.*)|# for eval safety \1|' -e \
  's|^.* ([^ ]*[^0-9])([0-9]+) +[A-Za-z]{3}  ?[0-9]+ [0-9:]+( \([^)]+\))?$|tn="\1";nr="\2"|')"

[ "$tn" = 'tty' -a -n "$nr" ] && {
  printf '\n%s\n' 'Welcome to jasperroDM!'
  while printf '\n\t%s\n\t%s\n\t%s\nChoose One:' \
      " 1 or <return>   Default startx" \
      " 2 t             TTY" \
      " 3 s             Shutdown"; do
    read x
    case "$x" in
      ''|1)
        # setsid causes the new non-root Xorg crash
        #setsid xinit ~/.xinitrc ...
        xinit ~/.xinitrc fvwm -- :"$nr" vt"$nr" -nolisten tcp -dpi 142 -keeptty
        exit
        break ;;
      2)
        break ;;
      3)
      	systemctl poweroff
	break ;;
      *)
        printf %s 'Unknown Answer' ;;
    esac
  done
}
unset tn nr x
