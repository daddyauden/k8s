#!/usr/bin/env sh
set -e

# create tls cert secret
# kubectl create secret tls ss-com-tls \
#   --cert=./pem/fullchain.cer \
#   --key=./pem/private.key

kubectl apply -f 01-rbac.yml -f 02-traefik.yml

# # Install Traefik Resource Definitions:
# kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.4/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

# # Install RBAC for Traefik:
# kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.4/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml

# or install from local file
kubectl apply -f kubernetes-crd-definition-v1.yml -f kubernetes-crd-rbac.yml
