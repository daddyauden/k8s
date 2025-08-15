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

helm install tempo grafana/tempo --version 1.23.2 --namespace $NS --create-namespace -f values.yaml

# helm upgrade tempo grafana/tempo --install --namespace $MONITORING_NS --create-namespace -f values.yaml