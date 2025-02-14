source ./config.sh

# Check if ADMIN_USER exists, create if it doesn't
if ! id "$ADMIN_USER" &>/dev/null; then
    echo "The user $ADMIN_USER does not exist. Creating user..."
    useradd -m $ADMIN_USER
    echo -e "$PASSWORD\n$PASSWORD" | passwd "$ADMIN_USER"
fi

# Check if USER exists, create if it doesn't
if ! id "$USER" &>/dev/null; then
    echo "The user $USER does not exist. Creating user..."
    useradd -m $USER
    echo -e "$PASSWORD\n$PASSWORD" | passwd "$USER"
fi

# Create the shared folder group
groupadd $SHARED_SHARED_FOLDER_GROUP_NAME


mkdir -p /home/$SHARED_FOLDER
chgrp $SHARED_FOLDER_GROUP_NAME /home/$SHARED_FOLDER
chmod 770 /home/$SHARED_FOLDER

# Set the SGID bit for the shared folder directory
chmod +s /home/$SHARED_FOLDER


usermod -a -G $SHARED_SHARED_FOLDER_GROUP_NAME $ADMIN_USER
usermod -a -G $SHARED_SHARED_FOLDER_GROUP_NAME $USER

echo "Shared folder setup completed successfully."
