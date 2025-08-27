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

helm install mimir grafana/mimir-distributed --version 5.7.0 --namespace $NS --create-namespace -f values.yaml

# helm upgrade mimir grafana/mimir-distributed --install --namespace $MONITORING_NS --create-namespace -f values.yaml