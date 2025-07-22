#!/usr/bin/env sh
set -e

ACCESS_KEY=$(openssl rand -hex 12)
SECRET_KEY=$(openssl rand -hex 32)

export ROOT_USER=$(kubectl get secret --namespace $NS minio-secrets -o jsonpath="{.data.accesskey}" | base64 -d)
export ROOT_PASSWORD=$(kubectl get secret --namespace $NS minio-secrets -o jsonpath="{.data.secretkey}" | base64 -d)

kubectl run --namespace $NS minio-client \
     --rm --tty -i --restart='Never' \
     --env MINIO_SERVER_ROOT_USER=$ROOT_USER \
     --env MINIO_SERVER_ROOT_PASSWORD=$ROOT_PASSWORD \
     --env MINIO_SERVER_HOST=minio \
     --image docker.io/bitnami/minio-client:2025.5.21-debian-12-r6 -- mc admin info