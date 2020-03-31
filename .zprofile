# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi

# If running from tty2 start gnome
if [[ -z $DISPLAY && $(tty) == /dev/tty2 && $XDG_SESSION_TYPE == tty ]]; then
  MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
fi
