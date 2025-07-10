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

kubectl create secret generic redis-secrets --from-literal=redis-password=redis-admin --from-literal=REDIS_PASSWORD=redis-admin -n $NS

helm install redis bitnami/redis --version 21.2.6 --namespace $NS --create-namespace -f values.yaml

# after update values.yaml, run it
# helm upgrade --install redis bitnami/redis --namespace $NS --create-namespace -f values.yaml --set global.redis.password=$REDIS_PASSWORD

# helm template redis bitnami/redis --version 21.2.6 --namespace $NS -f values.yaml > output.yaml