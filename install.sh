#!bin/bash

source script/config.sh

set -x

set -eo pipefail

echo -ne "
Starting...
"

./script/shared_folder.sh