#!/usr/bin/env sh
set -e

helm repo add argo https://argoproj.github.io/argo-helm

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

helm install argo-rollouts argo/argo-rollouts --version 2.40.0 --namespace $NS --create-namespace -f values.yaml
