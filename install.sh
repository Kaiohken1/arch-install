#!/bin/bash
set -x
set -eo pipefail

chmod +x script/*.sh

# Vérifier la présence du fichier config.sh
# if [ ! -f script/config.sh ]; then
#    echo "Error: config.sh not found!"
#    exit 1
# fi
# source script/config.sh

echo -ne "
Starting...
"

# Exécuter le script 01-volume.sh
if [ ! -f script/01-volume.sh ]; then
    echo "Error: 01-volume.sh not found!"
    exit 1
fi
(./script/01-volume.sh)
