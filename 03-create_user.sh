source ./config.sh
# wheel is used on lot of distribution to have admin privileges
useradd -m -G wheel $ADMIN_USER
useradd -m -G users $USER

echo -e "$PASSWORD\n$PASSWORD" | passwd "$ADMIN_USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd "$USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd

# delete "#" to use wheel groups for admin
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
