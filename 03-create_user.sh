source ./config.sh

arch-chroot /mnt /bin/bash <<EOF
useradd -G wheel $ADMIN_USER
useradd -G users $USER

chown -R "$USER:users" /home/"$USER"
chown -R "$ADMIN_USER:wheel" /home/"$ADMIN_USER"

echo -e "$PASSWORD\n$PASSWORD" | passwd "$ADMIN_USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd "$USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
EOF