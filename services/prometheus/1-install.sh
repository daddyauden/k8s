#!/usr/bin/env bash
set -e

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

# helm template prometheus prometheus-community/kube-prometheus-stack --version 75.9.0 --namespace $NS -f values.yaml --set domain="$DOMAIN" > output.yaml

helm install prometheus prometheus-community/kube-prometheus-stack --version 75.9.0 --namespace $NS --create-namespace -f values.yaml --set domain="$DOMAIN"

# helm upgrade prometheus prometheus-community/kube-prometheus-stack --install --namespace $NS --create-namespace -f values.yaml --set domain="$DOMAIN"