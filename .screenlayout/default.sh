#!/bin/sh
xrandr --output HDMI-1 --off --output DP-1 --off --output eDP-1 --primary --mode 1366x768 --pos 0x0 --rotate normal
$HOME/.config/wpg/wp_init.sh
~/.config/polybar/launchpolybar.sh
