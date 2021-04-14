#!/bin/sh
cd /data

echo "==> Recover backup archive $ARCHIVE_NAME"
gsutil cp gs://$BUCKET/$PREFIX/$ARCHIVE_NAME.tar.gz $ARCHIVE_NAME.tar.gz

echo "==> Extract archive"
tar xzf $ARCHIVE_NAME.tar.gz && rm $ARCHIVE_NAME.tar.gz

echo "==> Setup owner to $SEC_USER:$SEC_GROUP"
chown -R $SEC_USER:$SEC_GROUP .

echo "==> Done"