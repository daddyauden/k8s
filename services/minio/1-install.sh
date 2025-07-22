#!/usr/bin/env sh
set -e

helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

ACCESS_KEY=$(openssl rand -hex 12)
SECRET_KEY=$(openssl rand -hex 32)

kubectl create secret generic minio-secrets \
  --from-literal=accesskey=$ACCESS_KEY \
  --from-literal=secretkey=$SECRET_KEY \
  -n $NS

helm install minio bitnami/minio --version 17.0.9 --namespace $NS --create-namespace -f values.yaml --set ingress.hostname="s3.$DOMAIN" --set console.ingress.hostname="minio.$DOMAIN"

# helm upgrade minio bitnami/minio --install --namespace $NS --create-namespace -f values.yaml --set ingress.hostname="s3.$DOMAIN" --set console.ingress.hostname="minio.$DOMAIN"