#!/bin/bash

VERSION=$1

docker pull google/cloud-sdk:alpine
docker build -t eu.gcr.io/$PROJECT/s3-file-backup:latest .
docker build -t eu.gcr.io/$PROJECT/s3-file-backup:$VERSION .
docker push eu.gcr.io/$PROJECT/s3-file-backup:latest
docker push eu.gcr.io/$PROJECT/s3-file-backup:$VERSION
