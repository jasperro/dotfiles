#!/bin/sh
#i3lock -c C6915D \
#       --veriftext="..." --wrongtext="×" \
#       --timepos="x-90:h-ch-20" --datepos="x-90:h-ch+10" --indpos="x+290:h-120" \
#       --insidecolor=0c172199 --ringcolor=C6915D99 \
#       --insidevercolor=20649099 --ringvercolor=5C718A99 \
#       --insidewrongcolor=5C718A99 --ringwrongcolor=678DAB99 \
#       --keyhlcolor=A49B9C99 --bshlcolor=ddd4d099 \
#       --linecolor=9a949199 --separatorcolor=C6915D99 \
#       --radius 30 --ring-width 10 \
#       --blur 6 \
#       --clock --timestr="%H:%M" --timecolor="206490ff" --datecolor="867D86ff"

B='C6915Ddd'  # blank
C='206490dd'  # clear ish
D='5C718Add'  # default
T='867D86dd'  # text
W='678DABdd'  # wrong
V='678DABdd' # verifying

i3lock \
--blur 5 \
--bar-indicator \
--bar-position h \
--bar-direction 1 \
--bar-max-height 20 \
--bar-base-width 20 \
--bar-color 206490dd \
--keyhlcolor 678DABdd \
--bar-periodic-step 50 \
--bar-step 50 \
--bar-width 250 \
--redraw-thread \
\
--clock \
--force-clock \
--timepos 80:h-80 \
--timecolor C6915Ddd \
--datepos tx:ty-40 \
--datecolor 867D86ff \
--date-align 1 \
--time-align 1 \
--ringvercolor 5C718A88 \
--ringwrongcolor 20649088 \
--statuspos 5:h-16 \
--verif-align 1 \
--wrong-align 1 \
--verifcolor ffffffff \
--wrongcolor ffffffff \
--modifpos -50:-50 \
\
--screen 1
