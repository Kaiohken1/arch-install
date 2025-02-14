source ./config.sh

echo "Installing VirtualBox, Hyprland, and essential tools..."


echo "Configuring VirtualBox with its dedicated space..."
arch-chroot /mnt mkdir -p /var/lib/virtualbox
arch-chroot /mnt chown -R $ADMIN_USER:$ADMIN_USER /var/lib/virtualbox
echo "/dev/mapper/$VOLUME_GROUP-lvvmdata /var/lib/virtualbox ext4 defaults 0 2" >> /mnt/etc/fstab


# Hyprland configuration
echo "Setting up Hyprland custom configuration..."
arch-chroot /mnt mkdir -p /home/$ADMIN_USER/.config/hypr
arch-chroot /mnt mkdir -p /home/$USER/.config/hypr

# Hyprland config
cat <<EOF | arch-chroot /mnt tee /home/$ADMIN_USER/.config/hypr/hyprland.conf
# Monitor setup
monitor=,preferred

# Window layout
layout=master
master_layout=gaps_outer=10,gaps_inner=15,border_size=3

# Cursor settings
cursor_inactive_timeout=0
cursor_size=24

# Animations
animation=windows,1,10,default

# Keybindings (example)
bind=SUPER+ENTER,exec,kitty
bind=SUPER+Q,close
bind=SUPER+SPACE,workspace,e+1
bind=SUPER+F,fullscreen
EOF

arch-chroot /mnt chown -R $ADMIN_USER:$ADMIN_USER /home/$ADMIN_USER/.config/hypr
arch-chroot /mnt chown -R $USER:$USER /home/$USER/.config/hypr

echo "VirtualBox and Hyprland installation completed."