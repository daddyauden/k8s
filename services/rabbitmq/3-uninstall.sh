#!/usr/bin/env sh
set -e

NS=prod-mock

kubectl delete -f ingress.yaml

helm uninstall rabbitmq -n $NS

kubectl delete secret rabbitmq-secrets -n $NS
