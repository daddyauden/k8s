#!/usr/bin/env sh
set -e

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

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

# secret should be set the same namespace with ingress
kubectl create secret tls tls-domain --namespace=$NS --cert=pem/tls.crt --key=pem/tls.key

helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.12.3 --namespace ingress-nginx --create-namespace -f values.yaml

# after update values.yaml, run it
# helm upgrade ingress-nginx ingress-nginx/ingress-nginx --install --namespace ingress-nginx --create-namespace -f values.yaml
