#!/usr/bin/env sh
set -e

helm repo add bitnami https://charts.bitnami.com/bitnami

# ACCESS_KEY=$(openssl rand -hex 12)
# SECRET_KEY=$(openssl rand -hex 32)
ACCESS_KEY=ead36fa2a638f64ce5c74885
SECRET_KEY=5ef0ebfcb0fd30c02170fb6baba6f6fb82661836407f25751c5ccb13ae1aa0f4

kubectl create secret generic minio-secrets \
  --from-literal=accesskey=$ACCESS_KEY \
  --from-literal=secretkey=$SECRET_KEY

helm install minio bitnami/minio --version 17.0.16 -f values.yaml --set ingress.hostname="s3.$DOMAIN" --set console.ingress.hostname="minio.$DOMAIN"

# helm upgrade minio bitnami/minio --install -f values.yaml --set ingress.hostname="s3.$DOMAIN" --set console.ingress.hostname="minio.$DOMAIN"