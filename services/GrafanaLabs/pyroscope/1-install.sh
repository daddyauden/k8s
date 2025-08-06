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

helm install pyroscope grafana/pyroscope --version 1.14.1 --namespace $NS --create-namespace -f values.yaml --set pyroscope.structuredConfig.storage.s3.endpoint="s3.$DOMAIN"

# helm upgrade pyroscope grafana/pyroscope --install --namespace $NS --create-namespace -f values.yaml