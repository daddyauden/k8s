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

helm install loki grafana/loki --version 6.32.0 --namespace $NS --create-namespace -f values.yaml --set loki.storage.s3.endpoint="s3.$DOMAIN" --set loki.storage.object_store.s3.endpoint="s3.$DOMAIN"

# helm upgrade loki grafana/loki --install --namespace $NS --create-namespace -f values.yaml --set loki.storage.s3.endpoint="s3.$DOMAIN" --set loki.storage.object_store.s3.endpoint="s3.$DOMAIN"