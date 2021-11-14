#!/bin/bash

. ~/.local/bin/backup-scripts/general.sh

sudo cp -R /srv/nginx-proxy-manager /tmp/nginx-proxy-manager-temp

backup_folder /tmp/nginx-proxy-manager-temp nginx-proxy-manager

sudo rm -rf /tmp/nginx-proxy-manager-temp