# Keyboard stuff
xset led 3
setxkbmap -option ctrl:nocaps
setxkbmap br

# Mouse stuff
xinput set-prop 'HP, Inc HyperX Pulsefire Core' 'libinput Accel Speed' -0.7

# Window compositor and manager
xcompmgr -c &

# Montior positioning
xrandr --output HDMI-1 --primary
xrandr --output HDMI-1 --left-of eDP-1

# Set wallpaper
~/.fehbg &

# dwm program
dwmblocks &
# Notifiction handler
dunst &
exec dwm

# Adding self signed certificate for local https tests
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/selfsigned.key \
  -out /tmp/selfsigned.crt \
  -subj /"C=BR/ST=SP/L=SP/O=Carlo/OU=Carlo/CN=Carlo" > /dev/null 2>&1
