#!/bin/sh
NOW="$(date +%Y-%m-%d_%Hh%Mm%S)"

tar -C $PARENT_FOLDER -cvzf $ARCHIVE_NAME.tar.gz $RELATIVE_PATH

aws s3 cp $ARCHIVE_NAME.tar.gz s3://$AWS_ENDPOINT/$PREFIX/$ARCHIVE_NAME-$NOW.tar.gz --expires $(date -d "+$BACKUP_LIFESPAN days" +%Y-%m-%dT%H:%M:%SZ)
