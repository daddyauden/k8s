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

helm install argo-cd argo/argo-cd --version 8.3.0 --namespace $NS --create-namespace -f values.yaml --set global.domain="argocd.$DOMAIN"

# helm upgrade argo-cd argo/argo-cd --install --namespace $ARGO_NS --create-namespace -f values.yaml --set global.domain="argocd.$DOMAIN"

# kubectl -n $ARGO_NS get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
