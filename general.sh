#!/bin/bash

. ~/.local/bin/backup-scripts/settings.sh

function backup_db_file {
    SOURCE_FILE=$1
    NAME=$2
    EXTENSION="${SOURCE_FILE##*.}"

    FOLDER=/tmp
    FILENAME=$(get_backup_file_name $NAME).$EXTENSION
    FILEPATH=$FOLDER/$FILENAME

    cp $SOURCE_FILE $FILEPATH &&
    gzip $FILEPATH &&
    aws s3 mv $FILEPATH.gz s3://$S3_DB_BUCKET/$NAME/$FILENAME.gz

    rm $FILEPATH 2> /dev/null
    rm $FILEPATH.gz 2> /dev/null
}

function backup_folder {
    SOURCE_FOLDER=$1
    NAME=$2

    FOLDER=/tmp
    FILENAME=$(get_backup_file_name $NAME).tar.gz
    FILEPATH=$FOLDER/$FILENAME

    cd $SOURCE_FOLDER &&
    sudo tar zchf $FILEPATH . &&
    aws s3 cp $FILEPATH s3://$S3_SITE_BUCKET/$NAME/$FILENAME

    sudo rm $FILEPATH 2> /dev/null
}

function get_backup_file_name {
    echo $1_backup_$(date -u +"%y%m%d%H%M%S")
}