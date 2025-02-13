source /root/config.sh

# System configuation
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc
echo "$HOST" > /etc/hostname

pacman -Syu --noconfirm virtualbox gcc firefox sudo

