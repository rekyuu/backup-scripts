#!/bin/bash

. ~/.local/bin/backup-scripts/general.sh

function mediawiki_backup {
    SOURCE_FOLDER=/srv/http/$1

    backup_folder $SOURCE_FOLDER $1
}

mediawiki_backup "example-wiki"