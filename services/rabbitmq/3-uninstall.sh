#!/usr/bin/env sh
set -e

kubectl -n $NS delete ingress rabbitmq-ingress

helm uninstall rabbitmq -n $NS

kubectl delete secret rabbitmq-secrets -n $NS
