#!/usr/bin/env sh
set -e

helm repo add argo https://argoproj.github.io/argo-helm

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install argo-workflows argo/argo-workflows --version 0.45.19 --namespace $NS --create-namespace -f values.yaml
