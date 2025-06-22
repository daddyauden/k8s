#!/usr/bin/env sh
set -e

NS=prod-mock

helm uninstall redis-sentinel -n $NS

kubectl delete secret redis-secrets -n $NS

kubectl delete ns $NS
