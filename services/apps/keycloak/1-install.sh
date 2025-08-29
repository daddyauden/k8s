#!/usr/bin/env sh
set -e

NS=apps

helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create secret generic keycloak-secret --from-literal=admin-password=admin-keycloak --from-literal=db-user=keycloak --from-literal=db-password=MWlHeVNrNXIzSWNxRmpZDRtOTFLb0ZEaUhJ5Mno5Rko -n $NS

helm install keycloak bitnami/keycloak --version 25.2.0 -n $NS --create-namespace -f values.yaml --set ingress.hostname="identity.$DOMAIN"

# helm upgrade keycloak bitnami/keycloak --install -n apps --create-namespace -f values.yaml --set ingress.hostname="identity.$DOMAIN"
