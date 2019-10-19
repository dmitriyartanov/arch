#!/bin/bash

echo '1 Загрузка набора символов и установка шрифта'
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
 echo +10G;
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