#!/bin/sh
echo "==> Authenticate to gcloud"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
echo "==> Identify pod to backup"
POD=$(kubectl get pod -l $BACKUP_POD_LABEL -o name)
echo "==> Backup file from $POD:$PARENT_FOLDER/$RELATIVE_PATH"
kubectl exec $POD -- tar -C $PARENT_FOLDER $RELATIVE_PATH -cf - $RELATIVE_PATH | tar xfv - -C /data
echo "==> Compress backup into $ARCHIVE_NAME.tar.gz"
tar -C /data -czf $ARCHIVE_NAME.tar.gz .

VERSIONING_ENABLED=$(gsutil versioning get gs://$BUCKET/ | grep Enabled)
BUCKET_ARCHIVE_NAME=$ARCHIVE_NAME.tar.gz
if [ "$VERSIONING_ENABLED" == "" ];then
  echo "==> Add datetime in archive name (use versioning on the bucket if you want to remove it)"
  NOW="$(date +%Y-%m-%d_%Hh%Mm%S)"
  BUCKET_ARCHIVE_NAME=$ARCHIVE_NAME-$NOW.tar.gz
else
  echo "==> Versioning enabled on bucket. Use same archive name for all backup"
fi

echo "==> Sent arhcive to gs://$BUCKET/$PREFIX/$BUCKET_ARCHIVE_NAME"
gsutil cp $ARCHIVE_NAME.tar.gz gs://$BUCKET/$PREFIX/$BUCKET_ARCHIVE_NAME
echo "==> Done"
