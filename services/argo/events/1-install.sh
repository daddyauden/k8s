#!/usr/bin/env sh
set -e

NS=$ARGO_NS

helm repo add argo https://argoproj.github.io/argo-helm

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install argo-events argo/argo-events --version 2.4.16 --namespace $NS --create-namespace -f values.yaml

# helm upgrade argo-events argo/argo-events --namespace $ARGO_NS --create-namespace -f values.yaml