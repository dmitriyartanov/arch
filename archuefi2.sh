#!/bin/bash
read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username

echo '2.1 Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Asia/Omsk /etc/localtime

echo '2.2 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo '2.3 Обновим текущую локаль системы'
locale-gen

echo '2.4 Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo '2.5 Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo '2.6 Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo '2.7 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install /dev/sda

echo '2.8 Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

#echo 'Ставим программу для Wi-fi'
#pacman -S dialog wpa_supplicant --noconfirm

echo '2.9 Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username

echo '2.10 Создаем root пароль'
passwd

echo '2.11 Устанавливаем пароль пользователя'
passwd $username

echo '2.12 Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo '2.13 Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo '2.14 Ставим иксы и драйвера'
pacman -S xorg-server xorg-drivers xorg-xinit xf86-video-amdgpu

echo "2.15 Ставим XFCE"
pacman -S xfce4 xfce4-goodies --noconfirm

echo '2.16 Cтавим DM'
pacman -S lxdm --noconfirm
systemctl enable lxdm

echo '2.17 Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu --noconfirm 

echo '2.18 Ставим сеть'
systemctl enable dhcpcd
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo '2.19 Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

wget https://raw.githubusercontent.com/dmitriyartanov/arch/master/archuefi3.sh -O /home/$username/archuefi3.sh

echo 'Установка завершена!'
echo 'После перезагрзки и входа в систему, выполните команду:'
echo '$ sh ./archuefi3.sh'

exit

umount -R /mnt

reboot