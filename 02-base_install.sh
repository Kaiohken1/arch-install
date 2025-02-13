source /script/config.sh

echo "Installation of basics system"

pacstrap /mnt base linux linux-firmware lvm2 neovim
genfstab -U /mnt >> /mnt/etc/fstab

cp 03-users.sh 04-configure.sh /mnt/root/