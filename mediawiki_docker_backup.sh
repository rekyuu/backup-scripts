#! /bin/bash

. ~/.local/bin/backup-scripts/settings.sh

MW_NAME=$1
CONTAINER_ID=$(docker ps --filter="name=$MW_NAME" --format="{{.ID}}")
BACKUP_FILENAME=$(docker exec "$CONTAINER_ID" /scripts/mw-backup.sh)

cd "/srv/$MW_NAME/backups" || exit 1

aws s3 mv "$BACKUP_FILENAME" "s3://$S3_DB_BUCKET/$MW_NAME/$BACKUP_FILENAME" --only-show-errors

rm "$BACKUP_FILENAME"