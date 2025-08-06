#!/usr/bin/env bash
set -e

NS=$MONITORING_NS

helm repo add grafana https://grafana.github.io/helm-charts

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install loki grafana/loki --version 6.34.0 --namespace $NS --create-namespace -f values.yaml

# helm upgrade loki grafana/loki --install --namespace $NS --create-namespace -f values.yaml