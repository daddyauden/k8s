#!/usr/bin/env sh
set -e

helm uninstall rabbitmq -n $NS

kubectl delete secret rabbitmq-secrets -n $NS
