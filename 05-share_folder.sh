source ./config.sh

groupadd $SHARED_SHARED_FOLDER_GROUP_NAME
mkdir /home/$SHARED_FOLDER/
chgrp $SHARED_FOLDER_GROUP_NAME /home/$SHARED_FOLDER
chmod 770 /home/$SHARED_FOLDER/

#Set SGID bit for shared folder directory
chmod +s  /home/$SHARED_FOLDER

usermod -a -G $SHARED_SHARED_FOLDER_GROUP_NAME $ADMIN_USER
usermod -a -G $SHARED_SHARED_FOLDER_GROUP_NAME $USER