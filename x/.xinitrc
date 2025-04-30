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
