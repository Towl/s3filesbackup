#!/bin/sh
mkdir /data
NOW="$(date +%Y-%m-%d_%Hh%Mm%S)"
echo "==> Authenticate to gcloud"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
echo "==> Identify pod to backup"
POD=$(kubectl get pod -l $BACKUP_POD_LABEL -o name)
echo "==> Backup file from $POD:$PARENT_FOLDER/$RELATIVE_PATH"
kubectl exec $POD -- tar -C $PARENT_FOLDER $RELATIVE_PATH -cf - $RELATIVE_PATH | tar xfv - -C /data
echo "==> Compress backup into $ARCHIVE_NAME.tar.gz"
tar -C /data -czf $ARCHIVE_NAME.tar.gz .
echo "==> Sent arhcive to gs://$BUCKET/$PREFIX/$ARCHIVE_NAME-$NOW.tar.gz"
gsutil cp $ARCHIVE_NAME.tar.gz gs://$BUCKET/$PREFIX/$ARCHIVE_NAME-$NOW.tar.gz
echo "==> Done"
