#!/usr/bin/env sh
set -e

NS=$MONITORING_NS

helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install otel-collector open-telemetry/opentelemetry-collector --version 0.129.0 --namespace $NS --create-namespace -f values.yaml --set ingress.hosts[0].host="otel.$DOMAIN"

# after update values.yaml, run it
# helm upgrade otel-collector open-telemetry/opentelemetry-collector --install --namespace $NS --create-namespace -f values.yaml --set ingress.hosts[0].host="otel.$DOMAIN"
