#!/usr/bin/env sh
set -e

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ingress-nginx
  labels:
    kubernetes.io/metadata.name: ingress-nginx
    name: ingress-nginx
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: v1.31
EOF

helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.13.0 --namespace ingress-nginx --create-namespace -f values.yaml

# helm upgrade ingress-nginx ingress-nginx/ingress-nginx --install --namespace ingress-nginx --create-namespace -f values.yaml --set controller.config.use-forwarded-headers="true" --set controller.config.enable-real-ip="true"