#!/usr/bin/env sh
set -e

NS=prod-mock

helm uninstall rabbitmq -n $NS

kubectl delete secret rabbitmq-secrets -n $NS
