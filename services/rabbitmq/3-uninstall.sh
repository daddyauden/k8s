#!/usr/bin/env sh
set -e

NS=prod-mock

kubectl -n $NS delete ingress rabbitmq-ingress

helm uninstall rabbitmq -n $NS

kubectl delete secret rabbitmq-secrets -n $NS
