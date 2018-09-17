xsetroot -solid '#222255' &
autorandr -c &
compton &

sleep 1
unclutter &
nm-applet &
parcellite &
pasystray &
xautolock -locker "i3lock --color '#332233'"  -time 5 -detectsleep &
arbtt-capture -r 1 &
