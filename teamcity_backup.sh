#!/bin/bash

. ~/.local/bin/backup-scripts/general.sh

FOLDER=/srv/teamcity/data/backup
FILENAME=$(get_backup_file_name teamcity).zip
FILEPATH=$FOLDER/$FILENAME

function start_backup {
    curl --request POST \
        --url "${TEAM_CITY_DOMAIN}/app/rest/server/backup?fileName=${FILENAME}&addTimestamp=false&includeConfigs=true&includeDatabase=true&includeBuildLogs=true&includePersonalChanges=true&includeRunningBuilds=true&includeSupplimentaryData=true" \
        --header "${TEAM_CITY_AUTH}"
}

function get_current_backup_status {
    curl --request GET \
        --url "${TEAM_CITY_DOMAIN}/app/rest/server/backup" \
        --header "${TEAM_CITY_AUTH}"
}

start_backup

CURRENT_STATUS=$(get_current_backup_status)

while [[ $CURRENT_STATUS != "Idle" ]]
do
    sleep 1
    CURRENT_STATUS=$(get_current_backup_status)
done

aws s3 mv $FILEPATH s3://$S3_DB_BUCKET/teamcity/$FILENAME --only-show-errors

rm $FILEPATH 2> /dev/null