DWM_INSTALL = cd ./programs/dwm && make clean && make install; cd ./programs/dwmblocks && make clean && make install;

all: gemini pacman aur dwm dotfiles

gemini:
	bash ./scripts/.local/bin/install-gemini-assets

pacman:
	pacman -Sy - < ./programs/.pacmanlist

aur:
	bash ./install_aur.sh

dwm:
	$(DWM_INSTALL)

dotfiles:
	stow */

pkglist:
	cd ./programs && \
		pacman -Qqen > .pacmanlist && \
		pacman -Qqem > .pacmanlistaur

.PHONY: all gemini pacman aur dwm dotfiles pkglist
