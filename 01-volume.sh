#!/bin/bash

source ./config.sh

echo "Création des partitions sur $DISK"

parted -s $DISK mklabel gpt

parted -s $DISK mkpart primary fat32 1MiB 512MiB
parted -s $DISK set 1 esp on

parted -s $DISK mkpart primary ext4 512MiB 100%

partprobe $DISK

echo $PASSWORD | cryptsetup luksFormat --batch-mode $ROOT_PARTITION
echo $PASSWORD | cryptsetup open $ROOT_PARTITION $VG_NAME

pvcreate /dev/mapper/$VG_NAME
vgcreate $VOLUME_GROUP /dev/mapper/$VG_NAME

lvcreate -L 8G -n lvswap $VOLUME_GROUP
lvcreate -L 35G -n lvrootfs $VOLUME_GROUP
lvcreate -L 10G -n lvvmdata $VOLUME_GROUP
lvcreate -L 10G -n lvencrypteddata $VOLUME_GROUP
lvcreate -L 5G -n lvshared $VOLUME_GROUP
lvcreate -l 50%FREE -n lvhomeu $VOLUME_GROUP
lvcreate -l 100%FREE -n lvhomesu $VOLUME_GROUP

mkfs.ext4 /dev/$VOLUME_GROUP/lvrootfs
mkfs.ext4 /dev/$VOLUME_GROUP/lvhomeu
mkfs.ext4 /dev/$VOLUME_GROUP/lvhomesu
mkfs.ext4 /dev/$VOLUME_GROUP/lvvmdata
mkfs.ext4 /dev/$VOLUME_GROUP/lvencrypteddata
mkfs.ext4 /dev/$VOLUME_GROUP/lvshared
mkswap /dev/$VOLUME_GROUP/lvswap

mount /dev/$VOLUME_GROUP/lvrootfs /mnt

mkdir -p /mnt/home/user
mount /dev/$VOLUME_GROUP/lvhomeu /mnt/home/user

mkdir -p /mnt/home/son_user
mount /dev/$VOLUME_GROUP/lvhomesu /mnt/home/son_user

mkdir -p /mnt/var/vm
mount /dev/$VOLUME_GROUP/lvvmdata /mnt/var/vm

mkdir -p /mnt/dedicated_space
mount /dev/$VOLUME_GROUP/lvencrypteddata /mnt/dedicated_space

mkdir -p /mnt/home/shared
mount /dev/$VOLUME_GROUP/lvshared /mnt/home/shared

swapon /dev/$VOLUME_GROUP/lvswap

mkfs.fat -F32 $EFI_PARTITION
mkdir -p /mnt/boot
mount $EFI_PARTITION /mnt/boot

mkdir -p /mnt/etc
