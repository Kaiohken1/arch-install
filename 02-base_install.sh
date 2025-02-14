source ./config.sh

echo "Installation of basics system"
pacman -S --noconfirm archlinux-keyring
# Installs the essential packages: base system, development tools, Linux kernel, firmware, text editor (Neovim),
# networking tools (NetworkManager), bootloader (GRUB), and EFI boot manager (efibootmgr).
pacstrap /mnt base linux linux-headers linux-lts-headers linux-firmware nano vim intel-ucode btrfs-progs sof-firmware alsa-firmware lvm2

# Set the system timezone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
arch-chroot /mnt hwclock --systohc

echo "Configuration of the locale..."
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
echo "Configuration of the hostname..."
echo "archlinux" > /mnt/etc/hostname
# Sets the hostname of the system to "archlinux". This is used to identify the machine on a network.
echo "127.0.0.1 localhost" >> /mnt/etc/hosts
echo "::1       localhost" >> /mnt/etc/hosts
echo "127.0.1.1 archlinux.localdomain archlinux" >> /mnt/etc/hosts

# Enable essential services for the system
echo "Enabling essential services..."
arch-chroot /mnt systemctl enable NetworkManager

