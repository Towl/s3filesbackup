#!/bin/sh
echo "==> Recover code files from gs://$BUCKET/$PREFIX"
gsutil -m rsync -d -r gs://$BUCKET/$PREFIX /data

echo "==> Setup owner to $SEC_USER:$SEC_GROUP"
chown -R $SEC_USER:$SEC_GROUP /data

echo "==> Done"
