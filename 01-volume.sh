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

mkdir -p /mnt/home/user_father
mount /dev/$VOLUME_GROUP/lvhomeu /mnt/home/user_father

mkdir -p /mnt/home/user_son
mount /dev/$VOLUME_GROUP/lvhomesu /mnt/home/user_son

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

echo "Installation of basics system"
pacman -S --noconfirm archlinux-keyring
# Installs the essential packages: base system, development tools, Linux kernel, firmware, text editor (Neovim),
# networking tools (NetworkManager), bootloader (GRUB), and EFI boot manager (efibootmgr).
pacstrap -K /mnt base linux linux-headers linux-lts-headers linux-firmware nano vim intel-ucode btrfs-progs sof-firmware alsa-firmware lvm2 networkmanager 

genfstab -U /mnt >> /mnt/etc/fstab
echo "/dev/mapper/dedicated_space  none  ext4  defaults  0  0" >> /mnt/etc/fstab

mkdir -p /mnt/root/install-scripts
cp config.sh 02-base_install.sh 03-create_user.sh 04-external_install.sh 05-share_folder.sh 06-boot.sh /mnt/root/install-scripts/
chmod +x /mnt/root/install-scripts/*.sh
