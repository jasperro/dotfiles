SEL=$(printf "Suspend\nPower Off\nReboot\nLogout\n" | rofi -dmenu -p "Select Power Option")

if [ x"Suspend" = x"${SEL}" ]
then
    systemctl suspend
if [ x"Power Off" = x"${SEL}" ]
then
    systemctl poweroff
if [ x"Reboot" = x"${SEL}" ]
then
    systemctl reboot
if [ x"Logout" = x"${SEL}" ]
then
    i3-msg exit
fi
