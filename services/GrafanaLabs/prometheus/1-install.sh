#!/usr/bin/env bash
set -e

NS=$MONITORING_NS

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install prometheus prometheus-community/kube-prometheus-stack --version 75.9.0 --namespace $NS --create-namespace -f values.yaml --set grafana.ingress.hosts[0]="grafana.$DOMAIN"

# helm upgrade prometheus prometheus-community/kube-prometheus-stack --install --namespace $NS --create-namespace -f values.yaml --set grafana.ingress.hosts[0]="grafana.$DOMAIN"