#!/bin/bash
set -x
set -eo pipefail

echo -ne "
Starting...
"

bash 01-volume.sh
arch-chroot /mnt /bin/bash <<EOF
bash 02-base_install.sh
bash 03-create_user.sh
bash 04-external_install.sh
bash 05-share_folder.sh
bash 06-boot.sh
EOF

echo -ne "
Installation completed ready to us !...
"

