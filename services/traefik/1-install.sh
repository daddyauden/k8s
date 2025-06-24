#!/usr/bin/env sh
# set -e

helm repo add traefik https://traefik.github.io/charts

helm repo update

NS=prod-mock

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

# helm install traefik-crds traefik/traefik-crds --namespace $NS --create-namespace

helm install traefik traefik/traefik --version 36.1.0 --namespace $NS --create-namespace -f ./values.yaml

# helm install traefik traefik/traefik --version 36.1.0 \
#   --namespace $NS \
#   --create-namespace \
#   --set logs.general.level=INFO \
#   --set providers.kubernetesIngress.enabled=true


# update service type, as service type in values file do not work, must update
# helm upgrade traefik traefik/traefik --namespace $NS -f values.yaml --set service.type=NodePort
