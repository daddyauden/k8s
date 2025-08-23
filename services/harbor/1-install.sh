#!/usr/bin/env sh
set -e

helm repo add harbor https://helm.goharbor.io

kubectl create secret generic harbor-secrets \
  --from-literal=HARBOR_ADMIN_PASSWORD=Harbor12345

helm install harbor harbor/harbor --version 1.17.1 -f values.yaml --set expose.ingress.hosts.core="registry.$DOMAIN" --set externalURL="https://registry.$DOMAIN"

# helm upgrade harbor harbor/harbor --install --create-namespace -f values.yaml --set expose.ingress.hosts.core="registry.$DOMAIN" --set externalURL="https://registry.$DOMAIN"

kubectl create secret docker-registry regcred \
  --docker-server=registry.$DOMAIN \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  --docker-email=$REGISTRY_EMAIL