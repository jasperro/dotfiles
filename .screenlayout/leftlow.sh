#!/bin/sh
xrandr --output HDMI-1 --mode 1680x1050 --pos 1366x-100 --rotate normal --output DP-1 --off --output eDP-1 --primary --mode 1920x1080 --pos 0x400 --rotate normal
$HOME/.config/wpg/wp_init.sh &
~/.config/polybar/launchpolybar.sh 
