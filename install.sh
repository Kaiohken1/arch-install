#!/bin/bash
set -x
set -eo pipefail

echo -ne "
Starting...
"

bash 01-volume.sh
arch-chroot /mnt /bin/bash <<EOF
bash /root/install-scripts/03-create_user.sh
bash /root/install-scripts/04-external_install.sh
bash /root/install-scripts/05-share_folder.sh
bash /root/install-scripts/06-boot.sh
EOF

echo -ne "
Installation completed ready to us !...
"

