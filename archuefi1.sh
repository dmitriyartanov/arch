#!/bin/bash

echo '1.1 Загрузка набора символов и установка шрифта'
loadkeys ru
setfont cyr-sun16

echo '1.2 Синхронизация системных часов'
timedatectl set-ntp true

echo '1.3 создание разделов'
(
 echo g;

 echo n;
 echo;
 echo;
 echo +512M;
 echo t;
 echo 1;

 echo n;
 echo;
 echo;
 echo +8G;
 echo t;
 echo;
 echo 19;

 echo n;
 echo;
 echo;
 echo +70G;

 echo n;
 echo;
 echo;
 echo;

 echo w;
) | fdisk /dev/sda

echo 'Как вы разметили диск'
fdisk -l

echo '1.4 Отформатировать раздел подкачки'
mkswap /dev/sda2

echo '1.5 Включить раздел подкачки'
swapon /dev/sda2

echo '1.6 Форматирование дисков'

mkfs.fat -F32 /dev/sda1
mkfs.ext4  /dev/sda3
mkfs.ext4  /dev/sda4

echo '1.7 Монтирование дисков'
mount /dev/sda3 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mount /dev/sda4 /mnt/home

echo '1.8 Выбор зеркал для получения пакетов'
rm -rf /etc/pacman.d/mirrorlist
wget https://raw.githubusercontent.com/dmitriyartanov/arch/master/mirrorlist
mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

echo '1.9 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd

echo '1.10 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/dmitriyartanov/arch/master/archuefi2.sh)"
