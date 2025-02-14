source ./config.sh

arch-chroot /mnt /bin/bash <<EOF
echo "Installation de Hyprland et VirtualBox..."
pacman -S --noconfirm hyprland wayland xorg-xwayland foot swaybg

echo "Configuration de Hyprland..."
mkdir -p /home/$ADMIN_USER/.config/hypr
cat > /home/$ADMIN_USER/.config/hypr/hyprland.conf <<CONF
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
monitor = ,preferred,auto,1

input {
    kb_layout = fr
}

device:epic-mouse-v1 {
    sensitivity = -0.5
}
CONF
chown -R $ADMIN_USER:$ADMIN_USER /home/$ADMIN_USER/.config

pacman -S --noconfirm virtualbox virtualbox-host-modules-arch
usermod -aG vboxusers $ADMIN_USER

echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
EOF