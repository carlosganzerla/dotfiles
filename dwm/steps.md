Steps to install my desktop with DWM:

Install deps:

```
sudo apt install xorg stterm suckless-tools build-essential libxcursor1 \
    libxss1 x11-xserver-utils xinit xinput xserver-xorg-input-libinput \
    xbacklight libxinerama-dev libx11-dev x11-xserver-utils libxft-dev \
    libx11-dev xserver-xorg-input-libinput xbacklight xcompmgr

reboot
```

Then clone `dwm` and `dwmstatus` (`dmenu` optional atm) from suckless.

Create a .xinitrc file, with at least:

```
dwmstatus 2>&1 >/dev/null &
xcompmgr
exec dwm
```

startx

You may put it on your `~/.bash_profile`.

Install brave and neovim:

```
sudo snap install --beta --classic neovim
sudo snap install brave
```

If sound doesn't work, install:

```
sudo apt install pulseaudio
sudo apt install alsa
```

This is it for now.
