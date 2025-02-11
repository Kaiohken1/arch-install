USERNAME="user"
SON_USERNAME="user_son"
PASSWORD="azerty123"
SHARED_FOLDER="/home/shared"
DISK="/dev/sda"
EFI_PARTITION="/dev/sda1"
SWAP_PARTITION="/dev/sda2"
ROOT_PARTITION="/dev/sda3"
VOLUME_GROUP="archvg"

pvcreate $ROOT_PARTITION

vgcreate $VOLUME_GROUP $ROOT_PARTITION

lvcreate -L 8G -n lvswap $VOLUME_GROUP
lvcreate -L 50G -n lvrootfs $VOLUME_GROUP
lvcreate -L 10G -n lvvmdata $VOLUME_GROUP
lvcreate -L 5G -n lvhomeu $VOLUME_GROUP
lvcreate -L 5G -n lvhomesu $VOLUME_GROUP
lvcreate -L 10G -n lvencrypteddata $VOLUME_GROUP

cryptsetup luksFormat /dev/$VOLUME_GROUP/lvrootfs
cryptsetup open /dev/$VOLUME_GROUP/lvrootfs root

cryptsetup luksFormat /dev/$VOLUME_GROUP/lvswap
cryptsetup open /dev/$VOLUME_GROUP/lvswap swap

cryptsetup luksFormat /dev/$VOLUME_GROUP/lvencrypteddata
cryptsetup open /dev/$VOLUME_GROUP/lvencrypteddata dedicated_space

mkfs.ext4 /dev/mapper/root
mkfs.ext4 /dev/$VOLUME_GROUP/lvhomeu
mkfs.ext4 /dev/$VOLUME_GROUP/lvhomesu
mkfs.ext4 /dev/$VOLUME_GROUP/lvvmdata
mkfs.ext4 /dev/mapper/dedicated_space
mkswap /dev/mapper/swap

mount /dev/mapper/root /mnt

mkfs.fat -F32 $EFI_PARTITION
mount --mkdir $EFI_PARTITION /mnt/boot

swapon /dev/mapper/swap

genfstab -U /mnt >> /mnt/etc/fstab

echo "/dev/mapper/dedicated_space  none  ext4  defaults  0  0" >> /mnt/etc/fstab