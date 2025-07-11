#!/usr/bin/env sh
set -e

helm repo add harbor https://helm.goharbor.io

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

kubectl create secret generic harbor-secrets \
  --from-literal=HARBOR_ADMIN_PASSWORD=Harbor12345 \
  -n $NS

helm install harbor harbor/harbor --version 1.17.1 --namespace $NS --create-namespace -f values.yaml --set domain="$DOMAIN"

envsubst < ingress.yaml | kubectl apply -f -

# after update values.yaml, run it
# helm upgrade harbor harbor/harbor --install --namespace $NS --create-namespace -f values.yaml --set domain="$DOMAIN" --set global.defaultStorageClass=rook-ceph-block
