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

helm install argo-cd argo/argo-cd --version 8.1.3 --namespace $NS --create-namespace -f values.yaml --set global.domain="argocd.$DOMAIN" --set dex.livenessProbe.port=http --set dex.readinessProbe.port=http

# helm upgrade argo-cd argo/argo-cd --version 8.1.3 --namespace $NS -f values.yaml --set global.domain="argocd.$DOMAIN" --set dex.livenessProbe.port=http --set dex.readinessProbe.port=http

# kubectl -n $NS get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# helm template argo-cd argo/argo-cd --version 8.1.3 --namespace $NS -f values.yaml --set global.domain="argocd.$DOMAIN" --set dex.livenessProbe.port=http --set dex.readinessProbe.port=http > output.yaml
