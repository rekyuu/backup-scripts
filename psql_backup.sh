#!/bin/bash

. ~/.local/bin/backup-scripts/general.sh

CONTAINER_ID=$(docker ps | grep postgresql | awk '{print $1}')
DATABASES=$(docker exec --user postgres $CONTAINER_ID psql -q -A -t -c "SELECT datname FROM pg_database" \
    | egrep -v "teamcity|template0|template1|postgres")

for database in $DATABASES; do
    database=$(tr -dc '[[:print:]]' <<< "$database")
    
    FOLDER=/tmp
    FILENAME=$(get_backup_file_name $database).dump
    FILEPATH=$FOLDER/$FILENAME

    docker exec --user postgres $CONTAINER_ID pg_dump -Fc $database > $FILEPATH &&
    gzip $FILEPATH &&
    aws s3 mv $FILEPATH.gz s3://$S3_DB_BUCKET/$database/$FILENAME.gz --only-show-errors

    rm $FILEPATH 2> /dev/null
    rm $FILEPATH.gz 2> /dev/null
done