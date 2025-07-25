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

helm install mimir grafana/mimir-distributed --version 5.7.0 --namespace $NS --create-namespace -f values.yaml --set mimir.structuredConfig.common.storage.s3.endpoint="s3.$DOMAIN"

# helm upgrade mimir grafana/mimir-distributed --install --namespace $NS --create-namespace -f values.yaml --set mimir.structuredConfig.common.storage.s3.endpoint="s3.$DOMAIN"