#!/bin/bash

echo '1 Выбор локали клавишь и установка шрифта'
loadkeys ru
setfont cyr-sun16

echo '2 Синхронизация системных часов'
timedatectl set-ntp true

echo '3 создание разделов'
(
 echo g;

 echo n;
 echo;
 echo;
 echo +512M;
 echo y;
 echo t;
 echo 1;

 echo n;
 echo;
 echo;
 echo +70G;
 echo y;
 
  
 echo n;
 echo;
 echo;
 echo;
 echo y;
  
 echo w;
) | fdisk /dev/sda

echo 'Как вы разметили диск'
fdisk -l

echo '4 Форматирование дисков'

mkfs.fat -F32 /dev/sda1
mkfs.ext4  /dev/sda2
mkfs.ext4  /dev/sda3

echo '5 Монтирование дисков'
mount /dev/sda2 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mount /dev/sda3 /mnt/home

echo '6 Выбор зеркал для получения пакетов'
rm -rf /etc/pacman.d/mirrorlist
wget https://raw.githubusercontent.com/dmitriyartanov/arch/master/mirrorlist
mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

echo '7 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd

echo '8 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/dmitriyartanov/arch/master/archuefi2.sh)"
