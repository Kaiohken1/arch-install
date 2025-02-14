source ./config.sh

echo "Installation of basics system"
pacman -S --noconfirm archlinux-keyring
pacstrap -K /mnt base linux linux-headers linux-lts-headers linux-firmware nano vim intel-ucode btrfs-progs sof-firmware alsa-firmware lvm2 networkmanager 

genfstab -U /mnt >> /mnt/etc/fstab
echo "/dev/mapper/dedicated_space  none  ext4  defaults  0  0" >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
# Set the system timezone
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

echo "Configuration of the locale..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "Configuration of the hostname..."
echo "archlinux" > /etc/hostname
# Sets the hostname of the system to "archlinux". This is used to identify the machine on a network.
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 archlinux.localdomain archlinux" >> /etc/hosts

# Enable essential services for the system
echo "Enabling essential services..."
systemctl enable NetworkManager
EOF