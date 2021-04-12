FROM google/cloud-sdk:alpine

RUN gcloud components install kubectl

COPY backup.sh restore.sh install.sh /tmp/

RUN chmod a+x /tmp/backup.sh /tmp/restore.sh /tmp/install.sh

VOLUME ["/data"]

WORKDIR /tmp
