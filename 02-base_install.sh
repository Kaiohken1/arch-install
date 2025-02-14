source ./config.sh

echo "Installation of basics system"
pacman -S --noconfirm archlinux-keyring
# Installs the essential packages: base system, development tools, Linux kernel, firmware, text editor (Neovim),
# networking tools (NetworkManager), bootloader (GRUB), and EFI boot manager (efibootmgr).
pacstrap /mnt base linux linux-headers linux-lts-headers linux-firmware vim intel-ucode btrfs-progs sof-firmware alsa-firmware

genfstab -U /mnt >>/mnt/etc/fstab

# remove subvolid to avoid problems with restoring snapper snapshots
sed -i 's/subvolid=.*,//' /mnt/etc/fstab

# ensure nodiscard is in fstab (though we used that in mount, it is not preserved)
sed -i 's/noatime,compress/noatime,nodiscard,compress/' /mnt/etc/fstab

echo -ne "
Showing fstab
"

cat /mnt/etc/fstab

