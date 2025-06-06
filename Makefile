pkglist:
	cd ./programs && \
		pacman -Qqen > .pacmanlist && \
		pacman -Qqem > .pacmanlistaur;

# TODO: Automate AUR installation some day.
all:
	pacman -Sy - < ./programs/.pacmanlist;
	bash ./install_aur.sh;
	cd ./programs/dwm && make clean && make install;
	cd ./programs/dwmblocks && make clean && make install;
	stow */;

dwm:
	cd ./programs/dwm && make clean && make install;
	cd ./programs/dwmblocks && make clean && make install;

dotfiles:
	stow */;
