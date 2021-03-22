# S3 Files Backup

## Gcloud

Get the credentials file from IAM Gcloud and put it in a secret:

```bash
kubectl create secret generic gcloud-service-account --from-file=credentials=creds.json
```

Prepare environment variables:
```bash
BACKUP_POD_LABEL=something.com=backup # Label to identify pod to backup
PARENT_FOLDER='/'                     # Path of the parent folder from which the archive will be generated.
RELATIVE_PATH='.'                     # Relative path pointing to the files to put in archive. Relative to PARENT_FOLDER
ARCHIVE_NAME='something'              # Name of the generated archive (without extension)
BUCKET='bucket'                       # Name of the bucket
PREFIX='path/in/bucket'               # Path in the bucket where the archive will be sent.
```

Here is an example of a cronjob for Kubernetes using this container :

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: wordpress-plugins-backup
spec:
  schedule: "0 3 * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 2
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      ttlSecondsAfterFinished: 259200
      template:
        spec:
          containers:
          - name: s3filesbackup
            image: towl/s3filesbackup
            command: ["./backup.sh"]
            env:
              - name: GOOGLE_APPLICATION_CREDENTIALS
                value: /var/secrets/gcloud/creds.json
              - name: BACKUP_POD_LABEL
                value: app.kubernetes.io/instance=wordpress
              - name: PARENT_FOLDER
                value: /bitnami
              - name: RELATIVE_PATH
                value: wordpress/wp-content/plugins
              - name: ARCHIVE_NAME
                value: wordpress-plugins
              - name: BUCKET
                value: my-backup-bucket-wordpress
              - name: PREFIX
                value: backups/plugins
            resources:
              limits:
                cpu: 250m
                memory: 250M
              requests:
                cpu: 250m
                memory: 250M
              volumeMounts:
                - name: gcloud-credentials
                  mountPath: "/var/secrets/gcloud"
                  readOnly: true
          volumes:
            - name: gcloud-credentials
              secret:
                secretName: gcloud-service-account
                items:
                  - key: credentials
                    path: creds.json
          restartPolicy: OnFailure
```
