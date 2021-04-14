FROM google/cloud-sdk:alpine

RUN gcloud components install kubectl

COPY backup.sh restore.sh install-archive.sh install-code.sh save.sh /tmp/

RUN chmod a+x /tmp/backup.sh /tmp/restore.sh /tmp/install-archive.sh /tmp/install-code.sh /tmp/save.sh

VOLUME ["/data"]

WORKDIR /tmp
