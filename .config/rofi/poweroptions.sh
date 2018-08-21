SEL=$(printf "Suspend\nPower Off\nReboot\nLogout\n" | rofi -dmenu -i -p "Select Power Option")

if [ x"Suspend" = x"${SEL}" ]
then
    systemctl suspend
elif [ x"Power Off" = x"${SEL}" ]
then
    systemctl poweroff
elif [ x"Reboot" = x"${SEL}" ]
then
    systemctl reboot
elif [ x"Logout" = x"${SEL}" ]
then
    i3-msg exit
fi
