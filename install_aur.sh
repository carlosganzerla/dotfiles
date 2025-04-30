#!/bin/bash

AUR_PACKAGES=$(cat ./programs/.pacmanlistaur)

for pkg in $AUR_PACKAGES; do
    if pacman -Qi $pkg &>/dev/null; then
        valid_response=false
        while [[ "$valid_response" = false ]]; do
            echo "$pkg is already installed... Update? [y/n]"
            read -r yn
            case $yn in
                [yY] )
                    break
                    ;;
                [nN] )
                    echo "Skipping $pkg"
                    continue 2
                    ;;
                * )
                    echo "Invalid response. Please enter y or n."
                    ;;
            esac
        done
    fi

    echo "Installing $pkg..."
    git clone "https://aur.archlinux.org/${pkg}.git" /tmp/$pkg
    cd /tmp/$pkg
    makepkg -si --noconfirm
done
