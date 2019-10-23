#!/bin/bash

mkdir ~/builds
cd ~/builds

echo '3.1 Установка AUR (yay)'
sudo pacman -Syu
sudo pacman -S --noconfirm --needed wget curl git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --skipinteg
cd ..
rm -rf yay-bin

echo '3.2 Создаем нужные директории'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo '3.3 Установка программ'
sudo pacman -S firefox firefox-i18n-ru ufw f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru pulseaudio pavucontrol exfat-utils redshift --noconfirm

echo '3.4 Установка дополнительных программ'
sudo pacman -S recoll vlc smplayer freemind filezilla gimp gimp-nufraw geeqie libreoffice libreoffice-fresh-ru kdenlive audacity screenfetch transmission-gtk galculator klavaro calibre solaar bash-completion gnome-keyring seahorse mc --noconfirm
yay -S flameshot-git sublime-text-dev hunspell-ru google-chrome skypeforlinux-stable-bin --noconfirm

echo 'Включаем сетевой экран'
sudo ufw enable

echo 'Добавляем в автозагрузку:'
sudo systemctl enable ufw

echo 'Установка завершена!'
