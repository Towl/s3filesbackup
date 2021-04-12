FROM google/cloud-sdk:alpine

RUN gcloud components install kubectl

COPY backup.sh restore.sh install.sh /tmp && chmod a+x /tmp/*.sh

VOLUME ["/data"]

WORKDIR /tmp
