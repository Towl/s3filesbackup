FROM google/cloud-sdk

COPY backup.sh /tmp

RUN chmod a+x /tmp/backup.sh

WORKDIR /tmp
