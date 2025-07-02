#!/usr/bin/env sh
set -e

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm show values ingress-nginx/ingress-nginx > values-origin.yaml

NS=ingress-nginx

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
  labels:
    kubernetes.io/metadata.name: $NS
    name: $NS
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: v1.31
EOF

# secret should be set in the same namespace with ingress, in my case most service set in prod-mock namespace
kubectl create secret tls tls-test-com --namespace=prod-mock --cert=pem/tls.crt --key=pem/tls.key

helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.12.3 --namespace $NS --create-namespace -f values.yaml

# after update values.yaml, run it
# helm upgrade ingress-nginx ingress-nginx/ingress-nginx --install --namespace $NS --create-namespace -f values.yaml
