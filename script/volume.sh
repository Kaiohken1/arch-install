#!bin/bash

source /config.sh

lvcreate -L 8G -n lvswap $VOLUME_GROUP
lvcreate -L 50G -n lvrootfs $VOLUME_GROUP
lvcreate -L 10G -n lvvmdata $VOLUME_GROUP
lvcreate -L 5G -n lvhomeu $VOLUME_GROUP
lvcreate -L 5G -n lvhomesu $VOLUME_GROUP
lvcreate -L 10G -n lvencrypteddata $VOLUME_GROUP