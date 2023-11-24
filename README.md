# Dot files

This repo contains my dotfiles, and some other customizable programs like DWM
and DWMBlocks. It also contain my Arch packages.

## Useful programs

Some useful programs that are installed in my Arch:

- `xrandr`: manages displays.
- `dunst`: desktop notifications.
- `lf`: file manager.
- `notify-send`: test systems notifications.
- `stow`: creates symlinks for dotfiles.
- `startx`: Starts X server

## Install

Run `sudo make all` to install everything.

Run `make dotfiles` to update dotfiles

Run `sudo make dwm` to update DWM/DWMBLOCKS

Run `make pkglist` to update the installed programs.

I could not automate the installation of AUR packages, but they can be found on
`programs/.pacmanlistaur`.
