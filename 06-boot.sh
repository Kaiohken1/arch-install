source ./config.sh

UUID=$(blkid -s UUID -o value $ROOT_PARTITION)

arch-chroot /mnt /bin/bash <<EOF
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)/' /etc/mkinitcpio.conf

mkinitcpio -P

pacman -S --noconfirm grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=$UUID:cryptlvm root=/dev/$VOLUME_GROUP/lvrootfs\"|" /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
EOF