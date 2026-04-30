DWM_INSTALL = cd ./programs/dwm && make clean && make install; cd ./programs/dwmblocks && make clean && make install;

all: agents pacman aur dwm chmod dotfiles

agents:
	bash ./scripts/.local/bin/install-agent-assets

pacman:
	pacman -Sy - < ./programs/.pacmanlist

aur:
	install-aur

chmod:
	chmod +x ./scripts/.local/bin/*

dwm:
	$(DWM_INSTALL)

dotfiles:
	stow */
	git config core.hooksPath .git-hooks

pkglist:
	cd ./programs && \
		pacman -Qqen > .pacmanlist && \
		pacman -Qqem > .pacmanlistaur

.PHONY: all agents pacman aur dwm chmod dotfiles pkglist
