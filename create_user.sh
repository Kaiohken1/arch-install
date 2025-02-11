#!bin/bash


# delete "#" to use wheel groups for admin
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# user creation
# wheel is used on lot of distribution to have admin privileges
useradd -m -G wheel $ADMIN_USER
echo "$USERNAME:azerty123" | chpasswd
useradd -m -G users $USER
echo "$USER:azerty123" | chpasswd

