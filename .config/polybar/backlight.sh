case "$1" in
    --up)
      brightup
      ;;
    --down)
      brightdown
      ;;
esac
brightpercentage=$(echo $(cat /sys/class/backlight/intel_backlight/brightness)/77.2|bc)
echo $brightpercentage%
