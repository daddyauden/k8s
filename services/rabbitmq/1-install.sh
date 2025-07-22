#!/usr/bin/env sh
set -e

helm repo add bitnami https://charts.bitnami.com/bitnami

helm repo update

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

kubectl create secret generic rabbitmq-secrets --from-literal=rabbitmq-username=rabbitmq-admin --from-literal=rabbitmq-password=rabbitmq-admin -n $NS

helm install rabbitmq bitnami/rabbitmq --version 16.0.9 --namespace $NS --create-namespace -f values.yaml --set ingress.hostname="rabbitmq.$DOMAIN"

# helm upgrade rabbitmq bitnami/rabbitmq --install --namespace $NS --create-namespace -f values.yaml --set ingress.hostname="rabbitmq.$DOMAIN"
