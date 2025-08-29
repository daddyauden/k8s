#!/usr/bin/env sh
set -e

NS=apps

helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create secret generic wordpress-secret --from-literal=wordpress-password=Wordpress@admin -n $NS

helm install wordpress bitnami/wordpress --version 26.0.0 -n $NS --create-namespace -f values.yaml --set image.registry="registry.$DOMAIN" --set ingress.hostname="wp.$DOMAIN"

# helm upgrade wordpress bitnami/wordpress --install -n apps --create-namespace -f values.yaml --set image.registry="registry.$DOMAIN" --set ingress.hostname="wp.$DOMAIN"
