SEL=$(ls -1 ~/.screenlayout | sed 's/.sh//g' | rofi -dmenu -p "Select Screenlayout")

if [ -n "${SEL}" ]
then
    sh ~/.screenlayout/${SEL}.sh
fi
