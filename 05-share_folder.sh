source ./config.sh

arch-chroot /mnt /bin/bash <<EOF

# Create the shared folder group
groupadd $SHARED_SHARED_FOLDER_GROUP_NAME

chgrp $SHARED_FOLDER_GROUP_NAME /home/$SHARED_FOLDER
chmod 770 /home/$SHARED_FOLDER

# Set the SGID bit for the shared folder directory
chmod +s /home/$SHARED_FOLDER


usermod -a -G $SHARED_SHARED_FOLDER_GROUP_NAME $ADMIN_USER
usermod -a -G $SHARED_SHARED_FOLDER_GROUP_NAME $USER

echo "Shared folder setup completed successfully."
EOF