#!/usr/bin/env sh
# set -e

helm repo add traefik https://traefik.github.io/charts

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install traefik traefik/traefik --version 36.3.0 --namespace $NS --create-namespace -f ./values.yaml

# update service type, as service type in values file do not work, must update
# helm upgrade traefik traefik/traefik --namespace $NS -f values.yaml --set service.type=NodePort
