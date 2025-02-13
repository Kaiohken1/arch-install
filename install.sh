#!/bin/bash
set -x
set -eo pipefail

chmod 777 script/*

if [ ! -f script/config.sh ]; then
    echo "Error: config.sh not found!"
    exit 1
fi
source script/config.sh

echo -ne "
Starting...
"

# Execute shared folder script
#if [ ! -f script/09-shared_folder.sh ]; then
#    echo "Error: 09-shared_folder.sh not found!"
#    exit 1
#fi
#./script/09-shared_folder.sh


# Execute volume script

if [ ! -f 01-volume.sh ]; then
    echo "Error: 09-shared_folder.sh not found!"
    exit 1
fi
./01-volume.sh
