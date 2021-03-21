FROM amazon/aws-cli

RUN yum update -y && yum install -y tar && yum clean all && rm -rf /var/cache/yum

COPY backup.sh /tmp

RUN chmod a+x /tmp/backup.sh

WORKDIR /tmp
