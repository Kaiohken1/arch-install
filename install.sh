#!/bin/bash
set -x
set -eo pipefail

chmod +x script/*.sh

echo -ne "
Starting...
"

bash 01-volume.sh
bash 02-base-install.sh
bash 03-create_user.sh
bash 04-external_install.sh
bash 05-share_folder.sh
bash 06-boot.sh

echo -ne "
Installation completed ready to us !...
"

