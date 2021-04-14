#!/bin/sh
echo "==> Recover code files from gs://$BUCKET/$PREFIX"
echo "exec: gsutil -m cp -r gs://$BUCKET/$PREFIX /data"
gsutil -m cp -r gs://$BUCKET/$PREFIX /data

echo "==> Setup owner to $SEC_USER:$SEC_GROUP"
chown -R $SEC_USER:$SEC_GROUP /data

echo "==> Done"
