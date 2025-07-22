#!/usr/bin/env sh
set -e

helm repo add jaegertracing https://jaegertracing.github.io/helm-charts

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

# kubectl create secret generic jaeger-secrets \
#   --from-literal=HARBOR_ADMIN_PASSWORD=Harbor12345 \
#   -n $NS

helm install jaeger jaegertracing/jaeger --version 3.4.1 --namespace $NS --create-namespace -f values.yaml

# after update values.yaml, run it
# helm upgrade jaeger jaegertracing/jaeger --install --namespace $NS --create-namespace -f values.yaml
