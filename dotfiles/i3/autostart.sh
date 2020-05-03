feh --bg-fill ~/.config/i3/wallpaper.png --no-xinerama &

autorandr --change --default small &

sleep 1
ergo &
keynav &
unclutter &
nm-applet &
parcellite &
pasystray &
xautolock -locker "i3lock --color '#332233'"  -time 5 -detectsleep &
redshift -l -36.84853:174.76349 & # auckland, nz

