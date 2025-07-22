#!/usr/bin/env bash
set -e

NS=$MONITORING_NS

helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install tempo grafana/tempo --version 1.23.2 --namespace $NS --create-namespace -f values.yaml --set tempo.storage.trace.s3.endpoint="s3.$DOMAIN"

# helm upgrade tempo grafana/tempo --install --namespace $NS --create-namespace -f values.yaml --set tempo.storage.trace.s3.endpoint="s3.$DOMAIN"