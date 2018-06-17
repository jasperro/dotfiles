#!/bin/sh
#i3lock -c 587190 \
#       --veriftext="..." --wrongtext="×" \
#       --timepos="x-90:h-ch-20" --datepos="x-90:h-ch+10" --indpos="x+290:h-120" \
#       --insidecolor=0c181599 --ringcolor=58719099 \
#       --insidevercolor=827D8299 --ringvercolor=628FAE99 \
#       --insidewrongcolor=628FAE99 --ringwrongcolor=62AFCC99 \
#       --keyhlcolor=9F9BAB99 --bshlcolor=c3d1de99 \
#       --linecolor=88929b99 --separatorcolor=58719099 \
#       --radius 30 --ring-width 10 \
#       --blur 6 \
#       --clock --timestr="%H:%M" --timecolor="827D82ff" --datecolor="45A6C4ff"

B='587190dd'  # blank
C='827D82dd'  # clear ish
D='628FAEdd'  # default
T='45A6C4dd'  # text
W='62AFCCdd'  # wrong
V='62AFCCdd' # verifying

i3lock \
--blur 5 \
--bar-indicator \
--bar-position h \
--bar-direction 1 \
--bar-max-height 20 \
--bar-base-width 20 \
--bar-color 827D82dd \
--keyhlcolor 62AFCCdd \
--bar-periodic-step 50 \
--bar-step 50 \
--bar-width 250 \
--redraw-thread \
\
--clock \
--force-clock \
--timepos 80:h-80 \
--timecolor 587190dd \
--datepos tx:ty-40 \
--datecolor 45A6C4ff \
--date-align 1 \
--time-align 1 \
--ringvercolor 628FAE88 \
--ringwrongcolor 827D8288 \
--statuspos 5:h-16 \
--verif-align 1 \
--wrong-align 1 \
--verifcolor ffffffff \
--wrongcolor ffffffff \
--modifpos -50:-50 \
\
--screen 1
