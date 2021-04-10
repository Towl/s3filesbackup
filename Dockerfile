FROM google/cloud-sdk:alpine

RUN gcloud components install kubectl

COPY --chmod=755 backup.sh restore.sh install.sh /tmp

VOLUME ["/data"]

WORKDIR /tmp
