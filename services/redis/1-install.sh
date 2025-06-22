#!/usr/bin/env sh
set -e

NS=prod-mock

helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update

kubectl create namespace $NS

kubectl create secret generic redis-secrets --from-literal=redis-password=redis-admin -n $NS

helm install redis-sentinel bitnami/redis --namespace $NS --create-namespace -f values.yaml

# after update values.yaml, run it
# helm upgrade redis-sentinel bitnami/redis --namespace $NS -f values.yaml --set global.redis.password=$REDIS_PASSWORD
