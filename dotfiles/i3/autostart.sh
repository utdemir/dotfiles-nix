feh --bg-fill ~/.config/i3/wallpaper.png --no-xinerama &

autorandr -c &
compton --config ~/.config/compton.conf &

sleep 1
unclutter &
nm-applet &
parcellite &
pasystray &
xautolock -locker "i3lock --color '#332233'"  -time 5 -detectsleep &
