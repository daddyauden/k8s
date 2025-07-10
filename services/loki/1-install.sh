#!/usr/bin/env bash
set -e

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

# helm template loki grafana/loki --version 6.31.0 --namespace $NS -f values.yaml > output.yaml

helm install loki grafana/loki --version 6.31.0 --namespace $NS --create-namespace -f values.yaml

envsubst < ingress.yaml | kubectl apply -f -

# helm upgrade loki grafana/loki --install --namespace $NS --create-namespace -f values.yaml