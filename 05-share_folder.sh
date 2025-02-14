source ./config.sh

# Create the shared folder group
groupadd shared

chgrp shared /home/$SHARED_FOLDER
chmod 770 /home/$SHARED_FOLDER

# Set the SGID bit for the shared folder directory
chmod +s /home/$SHARED_FOLDER

usermod -a -G shared $ADMIN_USER
usermod -a -G shared $USER

echo "Shared folder setup completed successfully."
