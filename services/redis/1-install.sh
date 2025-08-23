#!/usr/bin/env sh
set -e

helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create secret generic redis-secrets --from-literal=redis-password=redis-admin --from-literal=REDIS_PASSWORD=redis-admin

helm install redis bitnami/redis --version 21.2.13 -f values.yaml

# helm upgrade --install redis bitnami/redis -f values.yaml