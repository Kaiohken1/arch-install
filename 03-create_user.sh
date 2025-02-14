source ./config.sh

arch-chroot /mnt /bin/bash <<EOF
useradd -m -G wheel $ADMIN_USER
useradd -m -G users $USER

echo -e "$PASSWORD\n$PASSWORD" | passwd "$ADMIN_USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd "$USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd

# delete "#" to use wheel groups for admin
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
EOF