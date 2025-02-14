#!/bin/bash

source ./config.sh

arch-chroot /mnt sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)/' /etc/mkinitcpio.conf

arch-chroot /mnt mkinitcpio -P

arch-chroot /mnt pacman -S --noconfirm grub efibootmgr

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

UUID=$(blkid -s UUID -o value $ROOT_PARTITION)

arch-chroot /mnt sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=$UUID:cryptlvm root=/dev/$VOLUME_GROUP/lvrootfs\"|" /etc/default/grub

arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
