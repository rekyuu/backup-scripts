#!/bin/bash

. ~/.local/bin/backup-scripts/general.sh

CONTAINER_ID=$(docker ps | grep postgresql | awk '{print $1}')
DATABASES=$(docker exec -it --user postgres $CONTAINER_ID psql -q -A -t -c "SELECT datname FROM pg_database" \
    | egrep -v "teamcity|template0|template1|postgres")

for database in $DATABASES; do
    database=$(tr -dc '[[:print:]]' <<< "$database")
    
    FOLDER=/tmp
    FILENAME=${database}_backup_$(date -u +"%y%m%d%H%M%S").dump
    FILEPATH=$FOLDER/$FILENAME

    docker exec -it --user postgres $CONTAINER_ID pg_dump -Fc $database > $FILEPATH &&
    backup_db_file $FILEPATH $database
done