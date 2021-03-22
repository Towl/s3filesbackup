#!/bin/sh
cd /data
echo "==> Authenticate to gcloud"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
echo "==> Identify pod to backup"
POD=$(kubectl get pod -l $BACKUP_POD_LABEL -o name)
echo "==> Recover backup archive $ARCHIVE_NAME at $DATE"
gsutil cp gs://$BUCKET/$PREFIX/$ARCHIVE_NAME-$DATE.tar.gz $ARCHIVE_NAME.tar.gz
echo "==> Extract archive"
tar xczf $ARCHIVE_NAME.tar.gz
echo "==> Copy extracted files $RELATIVE_PATH to remote $POD:$PARENT_FOLDER/$RELATIVE_PATH"
kubectl cp $RELATIVE_PATH $POD:$PARENT_FOLDER/$RELATIVE_PATH
echo "==> Done"
