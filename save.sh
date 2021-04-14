#!/bin/bash
echo "==> Identify pod to backup"
echo "exec: kubectl get pod -l $BACKUP_POD_LABEL -o name"
POD=$(kubectl get pod -l $BACKUP_POD_LABEL -o name)
echo "selected pod: $POD"

echo "==> Backup file from $POD:$PARENT_FOLDER/$RELATIVE_PATH"
tar_opts=($TAR_OPTS)
extract_cmd="kubectl exec $POD -- tar ${tar_opts[@]} -C $PARENT_FOLDER $RELATIVE_PATH -cf - $RELATIVE_PATH | tar xf - -C /data"
echo "exec: $extract_cmd"
eval $extract_cmd

echo "==> Save current files to gs://$BUCKET/$PREFIX"
echo "exec: gsutil -m rsync -d -r /data gs://$BUCKET/$PREFIX"
gsutil -m rsync -d -r /data gs://$BUCKET/$PREFIX

echo "==> Done"
