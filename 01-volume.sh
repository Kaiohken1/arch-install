#!bin/bash

source /config.sh


echo "Création des partitions sur $DISK"

parted -s $DISK mklabel gpt

parted -s $DISK mkpart ESP fat32 1MiB 512MiB
parted -s $DISK set 1 esp on

parted -s $DISK mkpart primary linux-swap 512MiB 8.5GiB

parted -s $DISK mkpart primary 8.5GiB 100%

partprobe $DISK
sleep 2

pvcreate $ROOT_PARTITION
vgcreate $VOLUME_GROUP $ROOT_PARTITION

lvcreate -L 8G -n lvswap $VOLUME_GROUP
lvcreate -L 40G -n lvrootfs $VOLUME_GROUP
lvcreate -L 10G -n lvvmdata $VOLUME_GROUP
lvcreate -L 10G -n lvencrypteddata $VOLUME_GROUP
lvcreate -l 50%FREE -n lvhomeu $VOLUME_GROUP
lvcreate -l 100%FREE -n lvhomesu $VOLUME_GROUP

cryptsetup luksFormat /dev/$VOLUME_GROUP/lvrootfs
cryptsetup open /dev/$VOLUME_GROUP/lvrootfs root

cryptsetup luksFormat --type luks1 /dev/$VOLUME_GROUP/lvswap
cryptsetup open /dev/$VOLUME_GROUP/lvswap swap

cryptsetup luksFormat /dev/$VOLUME_GROUP/lvencrypteddata
cryptsetup open /dev/$VOLUME_GROUP/lvencrypteddata dedicated_space

mkfs.ext4 /dev/mapper/root
mkfs.ext4 /dev/$VOLUME_GROUP/lvhomeu
mkfs.ext4 /dev/$VOLUME_GROUP/lvhomesu
mkfs.ext4 /dev/$VOLUME_GROUP/lvvmdata
mkfs.ext4 /dev/mapper/dedicated_space
mkswap /dev/mapper/swap

mkfs.fat -F32 $EFI_PARTITION

mount /dev/mapper/root /mnt
mount --mkdir $EFI_PARTITION /mnt/boot

mkdir -p /mnt/home/user
mount /dev/mapper/archvg-lvhomeu /mnt/home/user

mkdir -p /mnt/home/superuser
mount /dev/mapper/archvg-lvhomesu /mnt/home/superuser

mkdir -p /mnt/var/lib/libvirt
mount /dev/mapper/archvg-lvvmdata /mnt/var/lib/libvirt

mkdir -p /mnt/dedicated_space
mount /dev/mapper/dedicated_space /mnt/dedicated_space

swapon /dev/mapper/swap

genfstab -U /mnt >> /mnt/etc/fstab
echo "/dev/mapper/dedicated_space  none  ext4  defaults  0  0" >> /mnt/etc/fstab
