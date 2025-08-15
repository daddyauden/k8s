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

helm install argo-rollouts argo/argo-rollouts --version 2.40.3 --namespace $NS --create-namespace -f values.yaml --set dashboard.ingress.hosts[0]="argorollouts.${DOMAIN}"

# helm upgrade argo-rollouts argo/argo-rollouts --namespace $ARGO_NS --create-namespace -f values.yaml --set dashboard.ingress.hosts[0]="argorollouts.${DOMAIN}"