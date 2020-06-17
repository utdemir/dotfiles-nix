# Wallpaper:
#   By JJ Harrison (https://www.jjharrison.com.au/)
#   - Own work, CC BY-SA 4.0, https://commons.wikimedia.org/w/index.php?curid=90332278
feh --bg-fill ~/.config/i3/wallpaper.jpg --no-xinerama &

autorandr --change --default small &

sleep 1
picom &
ergo &
keynav &
unclutter &
nm-applet &
parcellite &
pasystray &
xautolock -locker "i3lock --color '#332233'"  -time 5 -detectsleep &
redshift -l -36.84853:174.76349 & # auckland, nz

