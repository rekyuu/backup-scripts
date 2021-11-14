#!/bin/bash

. ~/.local/bin/backup-scripts/general.sh

SOURCE=/srv/nginx-proxy-manager
DESTINATION=/tmp/nginx-proxy-manager-temp/nginx-proxy-manager

mkdir -p $DESTINATION

sudo cp -R $SOURCE $DESTINATION

cd $DESTINATION

backup_folder $DESTINATION nginx-proxy-manager

sudo rm -rf $DESTINATION