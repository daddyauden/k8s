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

helm install alloy grafana/alloy --version 1.2.0 --namespace $NS --create-namespace -f values.yaml --set ingress.hosts[0]="alloy.$DOMAIN"

# helm template alloy grafana/alloy --version 1.2.0 --namespace $NS -f values.yaml > output.yaml

# helm upgrade alloy grafana/alloy --install --namespace $NS --create-namespace -f values.yaml --set ingress.hosts[0]="alloy.$DOMAIN"